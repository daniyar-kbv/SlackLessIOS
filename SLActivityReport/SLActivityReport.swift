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
    private let componentsFactory: ComponentsFactory = ComponentsFactoryImpl()
    
    var body: some DeviceActivityReportScene {
        SummaryScene(appSettingsRepository: getRepositoryFactory().makeAppSettingsRepository())
        { .init(days: $0) }
    }
    
    private func getRepositoryFactory() -> RepositoryFactory {
        return componentsFactory.makeRepositoryFactory()
    }
}
