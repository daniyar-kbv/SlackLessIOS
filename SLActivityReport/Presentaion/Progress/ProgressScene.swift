//
//  ProgressScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import DeviceActivity
import SwiftUI

// Tech debt: refactor to use service

struct ProgressScene: DeviceActivityReportScene {
    let appSettingsRepository: AppSettingsRepository
    
    let context: DeviceActivityReport.Context = .progress
    let content: ([ARWeek]) -> ProgressRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek] {
        var weeks = [ARWeek]()
        let activitySegments = data.flatMap({
            $0.activitySegments
        })
        
        let startDate = Date().getLastDayOfWeek()
        let calendar = Calendar.current

        for i in (0..<5).reversed() {
            let lastDayOfWeek = calendar.date(byAdding: .weekOfYear, value: -i, to: startDate)!
            var days = [ARWeek.Day]()
            for j in (0..<7).reversed() {
                let date = calendar.date(byAdding: .day, value: -j, to: lastDayOfWeek)!
                guard let activitySegment = await activitySegments.first(where: {
                    getDate(from: $0.dateInterval.start) == getDate(from: date)
                }) else {
                    days.append(getEmptyDay(from: date))
                    continue
                }

                guard let appSelection = appSettingsRepository.output.getSelectedApps(for: date) else {
                    days.append(getEmptyDay(from: date))
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

                days.append(.init(weekday: calendar.component(.weekday, from: date),
                                  time: .init(slacked: slackedTime,
                                              total: activitySegment.totalActivityDuration,
                                              limit: nil,
                                              average: nil)))
            }

            weeks.append(.init(startDate: lastDayOfWeek.getFirstDayOfWeek(),
                               days: days))
        }

        return weeks
    }
}

extension ProgressScene {
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
