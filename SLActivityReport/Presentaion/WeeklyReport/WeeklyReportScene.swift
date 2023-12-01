//
//  WeeklyReportScene.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-26.
//

import DeviceActivity
import SwiftUI

struct WeeklyReportScene: DeviceActivityReportScene {
    let repository: Repository

    let context: DeviceActivityReport.Context = .weeklyReport
    let content: ([ARWeek]?) -> ProgressRepresentable

    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ARWeek]? {
        await ARProgress.makeConfiguration(representing: data, with: repository)
    }
}
