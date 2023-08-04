//
//  ProgressWeekRepresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import SwiftUI
import DeviceActivity

struct ProgressWeekRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProgressWeekReportController
    
    private let weeks: [ARWeek]
    
    init(weeks: [ARWeek]) {
        self.weeks = weeks
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        .init(viewModel: ProgressWeekReportViewModelImpl(weeks: weeks))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(weeks: weeks)
    }
}
