//
//  ProgressScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import DeviceActivity
import SwiftUI

struct ProgressScene: DeviceActivityReportScene {
    let appSettingsService: AppSettingsService

    let context: DeviceActivityReport.Context = .progress
    let content: ([ARWeek]) -> ProgressRepresentable

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek] {
        let calendar = Calendar.current
        let currentDate = Date()

        let activitySegments = data.flatMap {
            $0.activitySegments
        }

        guard let _ = await activitySegments.first(where: { _ in true })
        else { return [] }

        let weeks = (0 ..< 5)
            .reversed()
            .map {
                let date = currentDate.add(.weekOfYear, value: -$0)
                let startDate = date.getWeekInterval().start
                return ARWeek(startDate: startDate, days: [])
            }

        for await activitySegment in activitySegments {
            let date = activitySegment.dateInterval.start
            let week = weeks.first(where: {
                $0.startDate.getWeekInterval().containsDate(date)
            })

            var slackedTime = 0.0
            if let appSelection = appSettingsService.output.getSelectedApps(for: date) {
                slackedTime = await activitySegment
                    .categories
                    .flatMap { $0.applications }
                    .filter {
                        guard let token = $0.application.token,
                              $0.totalActivityDuration >= 60
                        else { return false }
                        return appSelection.applicationTokens.contains(token)
                    }
                    .map { $0.totalActivityDuration }
                    .reduce(0, +)
            }

            week?.days.append(.init(weekday: calendar.component(.weekday, from: date),
                                    time: .init(slacked: slackedTime,
                                                total: activitySegment.totalActivityDuration,
                                                limit: nil,
                                                average: nil)))
        }

        for week in weeks {
            for i in 0 ..< 7 {
                let date = week.startDate.add(.day, value: i)
                let weekday = calendar.component(.weekday, from: date)
                guard !week.days.contains(where: { $0.weekday == weekday }) else { continue }
                week.days.insert(getEmptyDay(from: date), at: i)
            }
        }

        return weeks
    }
}

extension ProgressScene {
    private func getEmptyDay(from date: Date) -> ARWeek.Day {
        let calendar = Calendar.current
        return .init(weekday: calendar.component(.weekday, from: date),
                     time: .init(slacked: 0,
                                 total: 0,
                                 limit: nil,
                                 average: nil))
    }
}
