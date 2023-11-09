//
//  ProgressScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import DeviceActivity
import SwiftUI

struct ProgressScene: DeviceActivityReportScene {
    let appSettingsService: AppSettingsService

    let context: DeviceActivityReport.Context = .progress
    let content: ([ARWeek]?) -> ProgressRepresentable

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek]? {
        await ARProgress.makeConfiguration(representing: data, with: appSettingsService)
    }
}
