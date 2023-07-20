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

final class SummaryReportController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryReportView()
    let viewModel: SummaryReportViewModel
    
    private(set) lazy var selectedAppsCollectionViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.selectedApps.value)
    private(set) lazy var selectedAppsCollectionController = SummarySelectedAppsCollectionViewController(viewModel: selectedAppsCollectionViewModel,
                                                                                                         parentViewModel: viewModel)
    private(set) lazy var otherAppsTableViewViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.otherApps.value)
    private(set) lazy var otherAppsTableViewController = SummaryOtherAppsTableViewController(viewModel: otherAppsTableViewViewModel,
                                                                                             parentViewModel: viewModel)

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
        bindView()
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
    
    private func bindView() {
        contentView.dateSwitcherView.leftButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: false)
            }
            .disposed(by: disposeBag)
        
        contentView.dateSwitcherView.rightButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.date
            .bind(to: contentView.dateSwitcherView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.time.subscribe(onNext: { [weak self] in
            self?.contentView.summarySelectedAppsDashboardView.set(time: $0)
            self?.contentView.otherAppsDashboardView.set(time: $0)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.selectedApps
            .subscribe(onNext: selectedAppsCollectionViewModel.input.update)
            .disposed(by: disposeBag)
        viewModel.output.otherApps
            .subscribe(onNext: otherAppsTableViewViewModel.input.update)
            .disposed(by: disposeBag)
        
        viewModel.output.isFirstDate.subscribe(onNext: { [weak self] in
                self?.contentView.dateSwitcherView.leftButton.isEnabled = !($0 ?? false)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLastDate.subscribe(onNext: { [weak self] in
                self?.contentView.dateSwitcherView.rightButton.isEnabled = !($0 ?? false)
            })
            .disposed(by: disposeBag)
    }
}
