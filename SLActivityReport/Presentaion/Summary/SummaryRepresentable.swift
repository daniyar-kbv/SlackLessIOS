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
    
    private let days: [ARDay]
    
    init(days: [ARDay]) {
        self.days = days
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(days: days))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(days: days)
    }
}
