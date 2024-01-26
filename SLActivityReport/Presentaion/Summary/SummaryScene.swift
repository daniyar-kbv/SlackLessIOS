//
//  SummaryScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI
import FamilyControls

typealias CategoryActivity = DeviceActivityData.CategoryActivity
typealias ApplicationActivity = DeviceActivityData.ApplicationActivity

struct SummaryScene: DeviceActivityReportScene {
    let repository: Repository
    
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
        else { return makeEmtyDay() }
        let date = activitySegment.dateInterval.start

        guard let appSelection = repository.getSelectedApps(for: date)
        else { return makeEmtyDay() }

        let timeLimit = repository.getTimeLimit(for: date)

        let categories: [CategoryActivity] = await activitySegment
            .categories
            .unwrap()

        let (selectedApps, otherApps) = await splitApps(in: categories, with: appSelection)
        
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
    
    private func splitApps(in categories: [CategoryActivity], with selection: FamilyActivitySelection) async -> (selected: [ApplicationActivity], other: [ApplicationActivity]) {
        var selectedApps = [ApplicationActivity]()
        var otherApps = [ApplicationActivity]()
        
        for category in categories {
            guard let categoryToken = category.category.token else { continue }
            if selection.categoryTokens.contains(categoryToken) {
                selectedApps.append(contentsOf: await category.applications.unwrap())
            } else {
                let applications: [ApplicationActivity] = await category.applications.unwrap()
                for app in applications {
                    guard let token = app.application.token else { continue }
                    if selection.applicationTokens.contains(token) {
                        selectedApps.append(app)
                    } else {
                        otherApps.append(app)
                    }
                }
            }
        }
        
        return (selectedApps, otherApps)
    }
    
    private func getTotalTime(of apps: [ApplicationActivity]) -> TimeInterval {
        apps.reduce(0) { $0 + $1.totalActivityDuration }
    }

    private func transform(apps: [ApplicationActivity]) -> [ARApp] {
        let times = apps.map { $0.totalActivityDuration }
        let (minTime, maxTime) = (times.min() ?? .zero, times.max() ?? .infinity)
        return apps
            .map({
                let appTimeRelative = $0.totalActivityDuration - minTime
                let timeDifference = maxTime - minTime
                return .init(name: $0.application.localizedDisplayName,
                             bundleId: $0.application.bundleIdentifier,
                             time: $0.totalActivityDuration,
                             ratio: appTimeRelative != 0 ? appTimeRelative / (timeDifference != 0 ? timeDifference : 1) : 0)
            })
            .sorted(by: { $0.time > $1.time })
    }
    
    private func makeEmtyDay() -> ARDay {
        return .init(date: Date(),
                     time: .init(slacked: 0,
                                 total: 0,
                                 limit: nil,
                                 average: nil),
                     selectedApps: [],
                     otherApps: [])
    }
}
