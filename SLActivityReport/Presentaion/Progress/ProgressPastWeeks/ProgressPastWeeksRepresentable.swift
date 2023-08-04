//
//  ProgressPastWeeksRepresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import SwiftUI
import DeviceActivity

struct ProgressPastWeeksRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProgressPastWeeksController
    
    private let weeks: [ARWeek]
    
    init(weeks: [ARWeek]) {
        self.weeks = weeks
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        .init(viewModel: ProgressPastWeeksViewModelImpl(weeks: weeks))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.set(weeks: weeks)
    }
}
