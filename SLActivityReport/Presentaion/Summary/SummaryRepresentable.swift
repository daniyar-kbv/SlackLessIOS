//
//  SummaryRepresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import DeviceActivity
import Foundation
import SwiftUI

struct SummaryRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SummaryController

    private let day: ARDay?

    init(day: ARDay?) {
        self.day = day
    }

    func makeUIViewController(context _: Context) -> UIViewControllerType {
        SummaryController(viewModel: SummaryViewModelImpl(day: day))
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context _: Context) {
        uiViewController.viewModel.input.set(day: day)
    }
}
