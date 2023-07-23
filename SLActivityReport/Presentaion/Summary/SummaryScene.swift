//
//  TotalActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

// Tech debt: refactor to use service

struct SummaryScene: DeviceActivityReportScene {
    let appSettingsRepository: AppSettingsRepository
    
    let context: DeviceActivityReport.Context = .summary
    let content: ([ARDay]) -> SummaryRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARDay] {
        var days = [ARDay]()
        let activitySegments = data.flatMap({
            $0.activitySegments
        })
        for await activitySegment in activitySegments {
            let date = activitySegment.dateInterval.start

            guard let appSelection = appSettingsRepository.output.getSelectedApps(for: date) else { continue }
            let timeLimit = appSettingsRepository.output.getTimeLimit(for: date)

            let allApps = activitySegment
                .categories
                .flatMap { $0.applications }
            let selectedApps = allApps
                .filter {
                    $0.
                    guard let token = $0.application.token else { return false }
                    return appSelection.applicationTokens.contains(token)
                }
            let otherApps = allApps
                .filter {
                    guard let token = $0.application.token else { return false }
                    return !appSelection.applicationTokens.contains(token) && $0.totalActivityDuration != 0
                }
            let slackedTime = await selectedApps
                .map { $0.totalActivityDuration }
                .reduce(0, +)
            let totalTime = await allApps
                .map { $0.totalActivityDuration }
                .reduce(0, +)
            
            var selectedMinTime: Double = .infinity
            var selectedMaxTime: Double = .zero
            for await app in selectedApps {
                if app.totalActivityDuration < selectedMinTime {
                    selectedMinTime = app.totalActivityDuration
                }
                if app.totalActivityDuration > selectedMaxTime {
                    selectedMaxTime = app.totalActivityDuration
                }
            }
            
            var otherMinTime: Double = .infinity
            var otherMaxTime: Double = .zero
            for await app in otherApps {
                if app.totalActivityDuration < otherMinTime {
                    otherMinTime = app.totalActivityDuration
                }
                if app.totalActivityDuration > otherMaxTime {
                    otherMaxTime = app.totalActivityDuration
                }
            }
            
            var selectedAppsTransformed = [ARApp]()
            for await app in selectedApps {
                let appTimeRelative = app.totalActivityDuration-selectedMinTime
                selectedAppsTransformed.append(.init(name: app.application.localizedDisplayName ?? "",
                                                     time: app.totalActivityDuration,
                                                     ratio: appTimeRelative != 0 ? appTimeRelative/(selectedMaxTime-selectedMinTime) : 0))
            }
            
            var otherAppsTransformed = [ARApp]()
            for await app in otherApps {
                let appTimeRelative = app.totalActivityDuration-otherMinTime
                otherAppsTransformed.append(.init(name: app.application.localizedDisplayName ?? "",
                                                  time: app.totalActivityDuration,
                                                  ratio: appTimeRelative != 0 ? appTimeRelative/(otherMaxTime-otherMinTime) : 0))
            }
            
            selectedAppsTransformed.sort(by: { $0.time > $1.time })
            otherAppsTransformed.sort(by: { $0.time > $1.time })
            
            days.append(.init(date: date,
                              time: .init(slacked: slackedTime,
                                          total: totalTime,
                                          limit: timeLimit,
                                          average: nil),
                              selectedApps: selectedAppsTransformed,
                              otherApps: otherAppsTransformed))
        }
        return days
    }
}
