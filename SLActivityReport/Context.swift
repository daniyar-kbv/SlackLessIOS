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
    static let summary = Self(SLReportType.summary.contextName)
    static let progress = Self(SLReportType.progress.contextName)
    static let weeklyReport = Self(SLReportType.weeklyReport.contextName)
}
