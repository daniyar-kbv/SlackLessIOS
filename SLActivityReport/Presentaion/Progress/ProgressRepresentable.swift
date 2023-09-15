//
//  ProgressRepresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import SwiftUI
import DeviceActivity

struct ProgressRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProgressController
    
    private let appSettingsService: AppSettingsService
    private let weeks: [ARWeek]
    
    init(appSettingsService: AppSettingsService,
         weeks: [ARWeek]) {
        self.appSettingsService = appSettingsService
        self.weeks = weeks
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        .init(viewModel: ProgressViewModelImpl(appSettingsService: appSettingsService, weeks: weeks))
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.viewModel.input.update(weeks: weeks)
    }
}

