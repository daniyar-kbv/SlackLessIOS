//
//  Context.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import Foundation
import SwiftUI

extension DeviceActivityReport.Context {
    static let summary = Self(SLDeviceActivityReportType.summary.contextName)
    static let progress = Self(SLDeviceActivityReportType.progress.contextName)
}
