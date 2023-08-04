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
        SummaryScene(appSettingsService: appComponentsFactory
            .makeDomainComponentsFactory()
            .makeServiceFactory()
            .makeAppSettingsService()) {
                .init(day: $0)
            }
        ProgressWeekScene(appSettingsService: appComponentsFactory
            .makeDomainComponentsFactory()
            .makeServiceFactory()
            .makeAppSettingsService()) {
                .init(weeks: $0)
            }
        ProgressPastWeeksScene(appSettingsService: appComponentsFactory
            .makeDomainComponentsFactory()
            .makeServiceFactory()
            .makeAppSettingsService()) {
                .init(weeks: $0)
            }
    }
}
