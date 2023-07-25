//
//  SLActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

//  Tech debt: refactor DI

@main
struct SLActivityReport: DeviceActivityReportExtension {
    private let appComponentsFactory = AppComponentsFactoryImpl()
    
    var body: some DeviceActivityReportScene {
        SummaryScene(appSettingsRepository: appComponentsFactory
            .makeDataComponentsFactory()
            .makeRepositoryFactory()
            .makeAppSettingsRepository()) {
            .init(days: $0)
        }
        ProgressScene(appSettingsRepository: appComponentsFactory
            .makeDataComponentsFactory()
            .makeRepositoryFactory()
            .makeAppSettingsRepository()) { .init(weeks: $0) }
    }
}
