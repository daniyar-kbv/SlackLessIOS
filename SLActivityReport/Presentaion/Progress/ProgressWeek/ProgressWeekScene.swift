//
//  ProgressWeekScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import DeviceActivity
import SwiftUI
import DeviceActivity

struct ProgressWeekScene: DeviceActivityReportScene {
    let appSettingsService: AppSettingsService
    
    let context: DeviceActivityReport.Context = .progressWeek
    let content: ([ARWeek]) -> ProgressWeekRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek] {
        var weeks = [ARWeek]()
        let activitySegments = data.flatMap({
            $0.activitySegments
        })
        
        let calendar = Calendar.current
        
        for i in (0..<2).reversed() {
            let date = calendar.date(byAdding: .weekOfYear, value: -i, to: Date())!
            let startDate = calendar.dateInterval(of: .weekOfYear, for: date)!.start
            weeks.append(.init(startDate: startDate, days: []))
        }
        
        for await activitySegment in activitySegments {
            let date = activitySegment.dateInterval.start
            let week = weeks.first(where: {
                calendar.dateInterval(of: .weekOfYear, for: $0.startDate)?.contains(date) ?? false
            })
            
            guard let appSelection = appSettingsService.output.getSelectedApps(for: date) else {
                week?.days.append(getEmptyDay(from: date))
                continue
            }
            
            let slackedTime = await activitySegment
                .categories
                .flatMap { $0.applications }
                .filter({ $0.totalActivityDuration >= 60 })
                .filter {
                    guard let token = $0.application.token else { return false }
                    return appSelection.applicationTokens.contains(token)
                }
                .map { $0.totalActivityDuration }
                .reduce(0, +)
            
            week?.days.append(.init(weekday: calendar.component(.weekday, from: date),
                              time: .init(slacked: slackedTime,
                                          total: activitySegment.totalActivityDuration,
                                          limit: nil,
                                          average: nil)))
        }
        
        for week in weeks {
            for i in (0..<7) {
                let date = calendar.date(byAdding: .day, value: i, to: week.startDate)!
                let weekday = calendar.component(.weekday, from: date)
                guard !week.days.contains(where: { $0.weekday == weekday }) else { continue }
                week.days.insert(getEmptyDay(from: date), at: i)
            }
        }
        
//        let startDate = Date().getLastDayOfWeek()
//
//        for i in (0..<2).reversed() {
//            let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: -i, to: startDate)!
//            var days = [ARWeek.Day]()
//            for j in (0..<7).reversed() {
//                let date = calendar.date(byAdding: .day, value: -j, to: lastDayOfWeek)!
//                guard let activitySegment = await activitySegments.first(where: {
//                    getDate(from: $0.dateInterval.end) == getDate(from: date)
//                }) else {
//                    days.append(getEmptyDay(from: date))
//                    continue
//                }
//
//                guard let appSelection = appSettingsRepository.output.getSelectedApps(for: date) else {
//                    days.append(getEmptyDay(from: date))
//                    continue
//                }
//
//                let slackedTime = await activitySegment
//                    .categories
//                    .flatMap { $0.applications }
//                    .filter({ $0.totalActivityDuration >= 60 })
//                    .filter {
//                        guard let token = $0.application.token else { return false }
//                        return appSelection.applicationTokens.contains(token)
//                    }
//                    .map { $0.totalActivityDuration }
//                    .reduce(0, +)
//
//                days.append(.init(weekday: calendar.component(.weekday, from: date),
//                                  time: .init(slacked: slackedTime,
//                                              total: activitySegment.totalActivityDuration,
//                                              limit: nil,
//                                              average: nil)))
//            }
//
//            weeks.append(.init(startDate: lastDayOfWeek.getFirstDayOfWeek(),
//                               days: days))
//        }

        return weeks
    }
}

extension ProgressWeekScene {
    private func getDate(from date: Date) -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.day, .month, .year], from: date)
    }
    
    private func getEmptyDay(from date: Date) -> ARWeek.Day {
        let calendar = Calendar.current
        return .init(weekday: calendar.component(.weekday, from: date),
                     time: .init(slacked: 0,
                                 total: 0,
                                 limit: nil,
                                 average: nil))
    }
}
