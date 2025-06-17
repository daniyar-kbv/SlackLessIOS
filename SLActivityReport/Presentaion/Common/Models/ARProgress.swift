//
//  ARProgress.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-26.
//

import DeviceActivity
import Foundation
import SwiftUI

// TODO: Add state management

typealias ActivitySegment = DeviceActivityData.ActivitySegment

struct ARProgress {
    private static var loadData = false
    
    static func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>,
                                  with repository: Repository) async -> [ARWeek]? {
        guard loadData else {
            loadData = true
            return nil
        }
        
        let days: [ARWeek.Day] = await data
            .flatMap({ $0.activitySegments })
            .compactMap({ await makeDay(activitySegment: $0,
                                        repository: repository) })
            .unwrap()
        
        guard !days.isEmpty else { return nil }

        var weeks = [ARWeek]()
        var currentDate = Date().getFirstDayOfWeek().add(.weekOfYear, value: -4)
        let lastDay = Date().getLastDayOfWeek()

        while currentDate <= lastDay {
            let week = getWeek(for: currentDate, from: &weeks)
            let day = days.first(where: { $0.date == currentDate }) ?? .init(date: currentDate, time: nil)
            week.days.append(day)
            currentDate = currentDate.add(.day, value: 1)
        }
        
        for week in weeks {
            week.days.sort(by: { $0.date < $1.date })
        }
        
        return weeks.sorted(by: { $0.startDate < $1.startDate })
    }

    private static func makeDay(activitySegment: ActivitySegment,
                                repository: Repository) async -> ARWeek.Day {
        let date = activitySegment.dateInterval.start
        var slackedTime = 0.0
        
        if let appSelection = repository.getSelectedApps(for: date) {
            let categories: [DeviceActivityData.CategoryActivity] = await activitySegment.categories.unwrap()
            
            for category in categories {
                guard let categoryToken = category.category.token else { continue }
                
                // Check if the entire category is selected
                if appSelection.categoryTokens.contains(categoryToken) {
                    let applications: [DeviceActivityData.ApplicationActivity] = await category.applications.unwrap()
                    // Filter out system services using intelligent detection
                    let filteredApps = applications.filter { SystemServiceFilter.isUserApp($0, selectedApps: appSelection) }
                    slackedTime += filteredApps.map { $0.totalActivityDuration }.reduce(0, +)
                } else {
                    let applications: [DeviceActivityData.ApplicationActivity] = await category.applications.unwrap()
                    for app in applications {
                        guard let token = app.application.token else { continue }
                        if appSelection.applicationTokens.contains(token) {
                            // Only count if it's a legitimate user app
                            if SystemServiceFilter.isUserApp(app, selectedApps: appSelection) {
                                slackedTime += app.totalActivityDuration
                            }
                        }
                    }
                }
            }
        }
        
        let totalTime = activitySegment.totalActivityDuration
        return .init(date: date, time: .init(slacked: slackedTime,
                                             total: totalTime,
                                             limit: nil,
                                             average: nil))
    }
    
    private static func getWeek(for date: Date, from weeks: inout [ARWeek]) -> ARWeek {
        guard let week = weeks.first(where: { $0.startDate.getWeekInterval().containsDate(date) })
        else {
            let week = ARWeek(startDate: date.getFirstDayOfWeek(), days: [])
            weeks.append(week)
            return week
        }
        
        return week
    }
}
