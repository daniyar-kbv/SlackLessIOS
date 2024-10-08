//
//  ProgressRepresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import DeviceActivity
import Foundation
import SwiftUI

struct ProgressRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProgressController

    private let repository: Repository
    private let type: SLProgressType
    private let weeks: [ARWeek]?

    init(repository: Repository,
         type: SLProgressType,
         weeks: [ARWeek]?)
    {
        self.repository = repository
        self.type = type
        self.weeks = weeks
    }

    func makeUIViewController(context _: Context) -> UIViewControllerType {
        .init(viewModel: ProgressViewModelImpl(repository: repository, type: type, weeks: weeks))
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context _: Context) {
        uiViewController.viewModel.input.update(weeks: weeks)
    }
}
