//
//  TotalActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

struct SummaryReportScene: DeviceActivityReportScene {
    let service: ActivityReportService
    let controller: SummaryInnerController
    
    let context: DeviceActivityReport.Context = .summary
    let content: (SummaryReport) -> SummaryControllerRepresentable
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> SummaryReport {
        let timelimit = service.getTimeLimit()
        let spentTime = await data
            .flatMap { $0.activitySegments }
            .flatMap { $0.categories }
            .flatMap { $0.applications }
            .filter {
                guard let tokens = self.service.getSelectedApplicationTokens(),
                      let token = $0.application.token
                else { return false }
                return tokens.contains(token)
            }
            .map { $0.totalActivityDuration }
            .reduce(0, +)
        return .init(spentTime: Int(spentTime),
                     timeLimit: Int(timelimit))
    }
}
