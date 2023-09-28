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
    private let appComponentsFactory = AppComponentsFactoryImpl()

    var body: some DeviceActivityReportScene {
        SummaryScene(appSettingsService: getServiceFactory().makeAppSettingsService()) {
            .init(day: $0)
        }
        ProgressScene(appSettingsService: getServiceFactory().makeAppSettingsService()) {
            .init(appSettingsService: getServiceFactory().makeAppSettingsService(), type: .normal, weeks: $0)
        }
        WeeklyReportScene(appSettingsService: getServiceFactory().makeAppSettingsService()) {
            .init(appSettingsService: getServiceFactory().makeAppSettingsService(), type: .weeklyReport, weeks: $0)
        }
    }

    private func getServiceFactory() -> ServiceFactory {
        appComponentsFactory
            .makeDomainComponentsFactory()
            .makeServiceFactory()
    }
}
