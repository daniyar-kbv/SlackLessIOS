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

struct SummaryControllerRepresentable: UIViewControllerRepresentable {
    private let viewModel = SummaryViewModelImpl()
    @State var report: SummaryReport
    
    func makeUIViewController(context: Context) -> some UIViewController {
        SummaryInnerController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
