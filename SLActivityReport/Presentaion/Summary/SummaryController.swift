//
//  SummaryController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SwiftUI
import UIKit

final class SummaryController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryView()
    let viewModel: SummaryViewModel

    private(set) lazy var selectedAppsCollectionViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.selectedApps.value)
    private(set) lazy var selectedAppsCollectionController = SummarySelectedAppsCollectionViewController(viewModel: selectedAppsCollectionViewModel)
    private(set) lazy var otherAppsTableViewViewModel = SummaryAppsCollectionViewModelImpl(apps: viewModel.output.otherApps.value)
    private(set) lazy var otherAppsTableViewController = SummaryOtherAppsTableViewController(viewModel: otherAppsTableViewViewModel)

    init(viewModel: SummaryViewModel) {
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
        viewModel.output.state
            .subscribe(onNext: { [weak self] in
                self?.update(state: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.time.subscribe(onNext: { [weak self] in
            self?.contentView.summarySelectedAppsDashboardView.set(time: $0)
            self?.contentView.otherAppsDashboardView.set(time: $0)
        })
        .disposed(by: disposeBag)

        viewModel.output.selectedApps
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                contentView.secondSectionFirstContentView.isHidden = $0.isEmpty
                selectedAppsCollectionViewModel.input.update(apps: $0)
            })
            .disposed(by: disposeBag)
        viewModel.output.otherApps
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                contentView.fourthSectionFirstContentView.isHidden = $0.isEmpty
                contentView.secondSectionView.isHidden = contentView.thirdSectionFirstContentView.isHidden && contentView.fourthSectionFirstContentView.isHidden
                otherAppsTableViewViewModel.input.update(apps: $0)
            })
            .disposed(by: disposeBag)
    }
}
