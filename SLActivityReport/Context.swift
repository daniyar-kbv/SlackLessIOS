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
    static let progress = Self(SLDeviceActivityReportType.progress.contextName)
}
