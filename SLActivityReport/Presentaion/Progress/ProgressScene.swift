//
//  ProgressScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import DeviceActivity
import SwiftUI

// Tech debt: refactor to use service

struct ProgressScene: DeviceActivityReportScene {
    let appSettingsRepository: AppSettingsRepository
    
    let context: DeviceActivityReport.Context = .summary
    let content: ([ARWeek]) -> ProgressRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek] {
        return MockData.getWeeks()
    }
}
