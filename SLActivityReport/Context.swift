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
    static let summary = Self(Constants.ContextName.summary)
    static let progressWeek = Self(Constants.ContextName.Progress.week)
    static let progressPastWeeks = Self(Constants.ContextName.Progress.pastWeeks)
}
