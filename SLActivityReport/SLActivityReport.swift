//
//  SLActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

@main
struct SLActivityReport: DeviceActivityReportExtension {
    private let dataComponentsFactory: DataComponentsFactory = DataComponentsFactoryImpl()

    var body: some DeviceActivityReportScene {
        SummaryScene(repository: dataComponentsFactory.makeRepository()) {
            .init(day: $0)
        }
        ProgressScene(repository: dataComponentsFactory.makeRepository()) {
            .init(repository: dataComponentsFactory.makeRepository(),
                  type: .normal,
                  weeks: $0)
        }
        WeeklyReportScene(repository: dataComponentsFactory.makeRepository()) {
            .init(repository: dataComponentsFactory.makeRepository(),
                  type: .weeklyReport,
                  weeks: $0)
        }
    }
}
