//
//  ActivityReportDay.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation

struct ActivityReportDay {
    let date: Date
    let time: ActivityReportTime
    let selectedApps: [ActivityReportApp]
    let otherApps: [ActivityReportApp]
}
