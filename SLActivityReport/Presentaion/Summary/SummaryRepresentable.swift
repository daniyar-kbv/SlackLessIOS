//
//  SummaryTestView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI
import DeviceActivity

struct SummaryRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SummaryReportController
    
    var days: [ARDay]
    
    func makeUIViewController(context: Context) -> SummaryReportController {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(days: days))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(days: days)
    }
}
