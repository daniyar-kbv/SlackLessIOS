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
    private let days: [ActivityReportDay]
    
    init(days: [ActivityReportDay]) {
        self.days = days
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(days: days))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
