//
//  SummaryScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI
import FamilyControls

typealias ApplicationActivity = DeviceActivityData.ApplicationActivity

struct SummaryScene: DeviceActivityReportScene {
    let appSettingsService: AppSettingsService
    
    let context: DeviceActivityReport.Context = .summary
    let content: (ARDay?) -> SummaryRepresentable
    
    private static var loadData = false
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ARDay? {
        guard Self.loadData else {
            Self.loadData = true
            return nil
        }
        
        guard let activitySegment = await data
            .flatMap({ $0.activitySegments })
            .first(where: { _ in true })
        else { return nil }

        let date = activitySegment.dateInterval.start

        guard let appSelection = appSettingsService.output.getSelectedApps(for: date)
        else { return nil }

        let timeLimit = appSettingsService.output.getTimeLimit(for: date)

        let allApps: [ApplicationActivity] = await activitySegment
            .categories
            .flatMap { $0.applications }
            .unwrap()

        let (selectedApps, otherApps) = splitApps(allApps, selection: appSelection)
        
        let totalTime = activitySegment.totalActivityDuration
        let slackedTime = getTotalTime(of: selectedApps)
        
        let selectedAppsTransformed = transform(apps: selectedApps)
        let otherAppsTransformed = transform(apps: otherApps)

        return .init(date: date,
                     time: .init(slacked: slackedTime,
                                 total: totalTime,
                                 limit: timeLimit,
                                 average: nil),
                     selectedApps: selectedAppsTransformed,
                     otherApps: otherAppsTransformed)
    }
    
    func splitApps(_ apps: [ApplicationActivity], selection: FamilyActivitySelection) -> (selected: [ApplicationActivity], other: [ApplicationActivity]) {
        var selectedApps = [ApplicationActivity]()
        var otherApps = [ApplicationActivity]()
        
        for app in apps {
            guard let token = app.application.token else { continue }
            if selection.applicationTokens.contains(token) {
                selectedApps.append(app)
            } else {
                otherApps.append(app)
            }
        }
        
        return (selectedApps, otherApps)
    }
    
    func getTotalTime(of apps: [ApplicationActivity]) -> TimeInterval {
        apps.reduce(0) { $0 + $1.totalActivityDuration }
    }

    func transform(apps: [ApplicationActivity]) -> [ARApp] {
        let times = apps.map { $0.totalActivityDuration }
        let (minTime, maxTime) = (times.min() ?? .zero, times.max() ?? .infinity)
        return apps
            .map({
                let appTimeRelative = $0.totalActivityDuration - minTime
                let timeDifference = maxTime - minTime
                return .init(name: $0.application.localizedDisplayName ?? "",
                             time: $0.totalActivityDuration,
                             ratio: appTimeRelative != 0 ? appTimeRelative / (timeDifference != 0 ? timeDifference : 1) : 0)
            })
            .sorted(by: { $0.time > $1.time })
    }
}
