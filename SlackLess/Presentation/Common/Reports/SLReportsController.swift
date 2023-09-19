//
//  SLReportsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-11.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SwiftUI
import UIKit

class SLReportsController: UIViewController {
    private let reports: [Report]
    private let viewModel: SLReportsViewModel
    private let notificationCenter = NotificationCenter.default
    let disposeBag = DisposeBag()

    init(reports: [Report],
         viewModel: SLReportsViewModel)
    {
        self.reports = reports
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.filters.subscribe(disposeBag: disposeBag) { [weak self] in
            self?.reports.getReport(of: $0)?.update(filter: $1)
        }

        reports.set(parentController: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.reports.reloadIfNeeded()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.reports.reloadIfNeeded()
        }
    }
}

extension SLReportsController {
    class Report {
        let reportType: SLDeviceActivityReportType
        var filter: DeviceActivityFilter?
        var hostingController: UIHostingController<DeviceActivityReport>
        let view: UIView
        weak var parentController: SLReportsController?

        init(reportType: SLDeviceActivityReportType,
             view: UIView)
        {
            self.reportType = reportType
            self.view = view
            hostingController = UIHostingController(rootView: DeviceActivityReport(reportType.getContext()))

            layoutHostingController()
        }

        func update(filter: DeviceActivityFilter) {
            self.filter = filter
            hostingController.rootView = DeviceActivityReport(reportType.getContext(), filter: filter)
        }

        func reloadIfNeeded() {
            guard hostingController.view.containsView(of: "EXPlaceholderView") else { return }
            parentController?.remove(controller: hostingController)
            addToParent()
        }

        func set(parentController: SLReportsController) {
            self.parentController = parentController
            addToParent()
        }

        private func addToParent() {
            guard let filter = filter else { return }
            hostingController = UIHostingController(rootView: DeviceActivityReport(reportType.getContext(), filter: filter))
            parentController?.add(controller: hostingController, to: view)
            layoutHostingController()
        }

        private func layoutHostingController() {
            hostingController.view.backgroundColor = SLColors.background1.getColor()
        }
    }
}

extension Array where Element: SLReportsController.Report {
    func reloadIfNeeded() {
        forEach { $0.reloadIfNeeded() }
    }

    func getReport(of type: SLDeviceActivityReportType) -> SLReportsController.Report? {
        first(where: { $0.reportType == type })
    }

    func set(parentController: SLReportsController) {
        forEach { $0.set(parentController: parentController) }
    }
}
