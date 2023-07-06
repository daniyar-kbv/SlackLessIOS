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
    private let service: ActivityReportService = ActivityReportServiceImpl(
        repositiryFactory: RepositoryFactoryImpl()
    )
    
    var body: some DeviceActivityReportScene {
        SummaryDashboardReportScene(service: service) { .init(report: $0) }
    }
}
