//
//  SummaryTestView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import Foundation
import SwiftUI
import DeviceActivity

struct SummaryRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SummaryReportController
    
    private let appInfoService: AppInfoService
    private let days: [ARDay]
    
    init(appInfoService: AppInfoService,
         days: [ARDay]) {
        self.appInfoService = appInfoService
        self.days = days
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(appInfoService: appInfoService,
                                                                      days: days))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(days: days)
    }
}
