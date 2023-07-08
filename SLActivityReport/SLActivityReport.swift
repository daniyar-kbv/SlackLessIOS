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
        SummaryReportScene(service: componentsFactory.makeActivityReportService(),
                           controller: componentsFactory.makeControllersFactory().makeSummaryController())
        { .init(report: $0) }
    }
}
