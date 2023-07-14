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
    private let time: ActivityReportTime
    
    init(time: ActivityReportTime) {
        self.time = time
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ActivityReportSummaryController(viewModel: ActivityReportSummaryViewModelImpl(time: time))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
