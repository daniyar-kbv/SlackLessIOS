//
//  TotalActivityView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import SwiftUI

struct SummaryDashboardContainerView: UIViewControllerRepresentable {
    let report: SummaryDashboardReport
    
    init(report: SummaryDashboardReport) {
        self.report = report
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return SummaryDashboardController(report: report)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct SummaryDashboardContainerViewPreview: PreviewProvider {
    static var previews: some View {
        SummaryDashboardContainerView(report: .init(remainingTime: 5000, totalTime: 7200))
    }
}
