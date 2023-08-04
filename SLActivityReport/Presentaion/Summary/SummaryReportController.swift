//
//  SummaryCOntroller.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import DeviceActivity
import SwiftUI

// TODO: add loader

final class SummaryReportController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryReportView()
    let viewModel: SummaryReportViewModel
    
    private(set) lazy var selectedAppsCollectionViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.selectedApps.value)
    private(set) lazy var selectedAppsCollectionController = SummarySelectedAppsCollectionViewController(viewModel: selectedAppsCollectionViewModel)
    private(set) lazy var otherAppsTableViewViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.otherApps.value)
    private(set) lazy var otherAppsTableViewController = SummaryOtherAppsTableViewController(viewModel: otherAppsTableViewViewModel)

    init(viewModel: SummaryReportViewModel) {
        self.viewModel = viewModel

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        bindViewModel()
    }
    
    private func configView() {
        contentView.summarySelectedAppsDashboardView.set(time: viewModel.output.time.value)
        contentView.otherAppsDashboardView.set(time: viewModel.output.time.value)
        add(controller: selectedAppsCollectionController,
            to: contentView.secondSectionFirstContentView)
        add(controller: otherAppsTableViewController,
            to: contentView.fourthSectionFirstContentView)
    }
    
    private func bindViewModel() {
        viewModel.output.time.subscribe(onNext: { [weak self] in
            $0 == nil ? self?.showLoader() : self?.hideLoader()
            self?.contentView.summarySelectedAppsDashboardView.set(time: $0)
            self?.contentView.otherAppsDashboardView.set(time: $0)
            self?.contentView.thirdSectionFirstContentView.isHidden = true
        })
        .disposed(by: disposeBag)
        
        viewModel.output.selectedApps
            .subscribe(onNext: { [weak self] in
                self?.contentView.secondSectionFirstContentView.isHidden = $0.isEmpty
                self?.selectedAppsCollectionViewModel.input.update(apps: $0)
            })
            .disposed(by: disposeBag)
        viewModel.output.otherApps
            .subscribe(onNext: { [weak self] in
                self?.contentView.fourthSectionFirstContentView.isHidden = $0.isEmpty
                self?.otherAppsTableViewViewModel.input.update(apps: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func showLoader(_ show: Bool) {
        contentView.isHidden = show
        show ? showLoader() : hideLoader()
    }
}
