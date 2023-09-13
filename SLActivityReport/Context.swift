//
//  Context.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import Foundation
import SwiftUI
import DeviceActivity

extension DeviceActivityReport.Context {
    static let summary = Self(SLDeviceActivityReportType.summary.contextName)
    static let progressWeek = Self(SLDeviceActivityReportType.week.contextName)
    static let progressPastWeeks = Self(SLDeviceActivityReportType.pastWeeks.contextName)
}
