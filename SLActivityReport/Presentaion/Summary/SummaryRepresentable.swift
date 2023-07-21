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
    
    private let iTunesService: ITunesService
    private let days: [ARDay]
    
    init(iTunesService: ITunesService, days: [ARDay]) {
        self.iTunesService = iTunesService
        self.days = days
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        SummaryReportController(viewModel: SummaryReportViewModelImpl(iTunesService: iTunesService,
                                                                      days: days))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(days: days)
    }
}
