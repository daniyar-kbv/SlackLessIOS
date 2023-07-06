//
//  TotalActivityTestReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-04.
//

import Foundation
import DeviceActivity
import SwiftUI

struct TotalActivityTestReport: DeviceActivityReportScene {
    
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .totalTestActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (ActivityTestReport) -> TotalActivityTestView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityTestReport {
        // Reformat the data into a configuration that can be used to create
        // the report's view.
        var res = ""
        var list: [AppDeviceTestActivity] = []
        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0, {
            $0 + $1.totalActivityDuration
        })
        for await d in data {
            res += d.user.appleID!.debugDescription
            res += d.lastUpdatedDate.description
            for await a in d.activitySegments{
                res += a.totalActivityDuration.formatted()
                for await c in a.categories {
                    for await ap in c.applications {
                        let appName = (ap.application.localizedDisplayName ?? "nil")
                        let bundle = (ap.application.bundleIdentifier ?? "nil")
                        let duration = ap.totalActivityDuration
                        let numberOfPickups = ap.numberOfPickups
                        let app = AppDeviceTestActivity(id: bundle, displayName: appName, duration: duration, numberOfPickups: numberOfPickups)
                        list.append(app)
                    }
                }
            }
        }

        return ActivityTestReport(totalDuration: totalActivityDuration, apps: list)
    }
}


