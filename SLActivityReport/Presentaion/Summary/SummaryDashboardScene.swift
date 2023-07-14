//
//  TotalActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

struct SummaryScene: DeviceActivityReportScene {
    let appSettingsRepository: AppSettingsRepository
    let context: DeviceActivityReport.Context = .summary
    let content: (ActivityReportTime) -> SummaryRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReportTime {
        let timeLimit = appSettingsRepository.output.getTimeLimit()
        let allApps = data
            .flatMap { $0.activitySegments }
            .flatMap { $0.categories }
            .flatMap { $0.applications }
        let totalTime = await allApps
            .map { $0.totalActivityDuration }
            .reduce(0, +)
        let slackedTime = await allApps
            .filter {
                guard let tokens = self.appSettingsRepository.output.getSelectedApps()?.applicationTokens,
                      let token = $0.application.token
                else { return false }
                return tokens.contains(token)
            }
            .map { $0.totalActivityDuration }
            .reduce(0, +)
        return .init(slacked: slackedTime,
                     total: totalTime,
                     limit: timeLimit)
    }
}
