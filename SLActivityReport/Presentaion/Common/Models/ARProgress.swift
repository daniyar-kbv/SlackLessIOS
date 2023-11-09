//
//  ARProgress.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-26.
//

import DeviceActivity
import Foundation
import SwiftUI

typealias ActivitySegment = DeviceActivityData.ActivitySegment

struct ARProgress {
    private static var loadData = false
    
    static func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>,
                                  with appSettingsService: AppSettingsService) async -> [ARWeek]? {
        guard loadData else {
            loadData = true
            return nil
        }
        
        let days: [ARWeek.Day] = await data
            .flatMap({ $0.activitySegments })
            .compactMap({ await makeDay(activitySegment: $0,
                                        appSettingsService: appSettingsService) })
            .unwrap()
        
//        FIXME: Refactor this
        
        guard days.count > 1 else { return nil }

        var weeks = [ARWeek]()
        var currentIndex = 0
        var currentDate = Date().getFirstDayOfWeek().add(.weekOfYear, value: -4)
        let lastDay = Date().getLastDayOfWeek()

        while currentDate <= lastDay {
            let week = getLastWeek(for: currentDate, from: &weeks)

            var day: ARWeek.Day!
            if currentIndex < days.count {
                day = days[currentIndex]
                currentIndex += 1
            } else if let lastDay = days.last {
                day = lastDay
            }

            switch currentDate.compareByDate(to: day.date) {
            case .orderedAscending, .orderedDescending:
                week.days.append(makeEmptyDay(from: currentDate))
            case .orderedSame:
                week.days.append(day)
            }

            currentDate = currentDate.add(.day, value: 1)
        }

        return weeks
    }

    private static func makeDay(activitySegment: ActivitySegment, appSettingsService: AppSettingsService) async -> ARWeek.Day {
        let date = activitySegment.dateInterval.start
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

        return .init(date: date,
                     time: .init(slacked: slackedTime,
                                 total: activitySegment.totalActivityDuration,
                                 limit: nil,
                                 average: nil))
    }
    
    private static func getLastWeek(for date: Date, from weeks: inout [ARWeek]) -> ARWeek {
        guard let lastWeek = weeks.last,
              lastWeek.startDate.getWeekInterval().containsDate(date)
        else {
            let week = ARWeek(startDate: date.getFirstDayOfWeek(), days: [])
            weeks.append(week)
            return week
        }
        
        return lastWeek
    }

    private static func makeEmptyDay(from date: Date) -> ARWeek.Day {
        return .init(date: date,
                     time: .init(slacked: 0,
                                 total: 0,
                                 limit: nil,
                                 average: nil))
    }
}
