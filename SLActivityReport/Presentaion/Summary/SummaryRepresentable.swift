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
    
    private let day: ARDay?
    
    init(day: ARDay?) {
        self.day = day
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(day: day))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(day: day)
    }
}
