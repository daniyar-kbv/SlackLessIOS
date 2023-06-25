//
//  SummaryDashboardController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit

final class SummaryDashboardController: UIViewController {
    private let contentView = SummaryDashboardView()
    private let report: SummaryDashboardReport
    
    init(report: SummaryDashboardReport) {
        self.report = report
        
        super.init(nibName: .none, bundle: .none)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    
}

