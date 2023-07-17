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

final class SummaryPageController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SummaryPageViewModel
    private let contentView: SummaryPageView
    
    private(set) lazy var selectedAppsCollectionController: SummarySelectedAppsCollectionViewController = {
        let viewModel = SummaryAppsCollectionViewModelImpl(appsInfo: viewModel.output.getSelectedApps())
        return .init(viewModel: viewModel)
    }()
    
    private(set) lazy var otherAppsTableViewController: SummaryOtherAppsTableViewController = {
        let viewModel = SummaryAppsCollectionViewModelImpl(appsInfo: viewModel.output.getSelectedApps())
        return .init(viewModel: viewModel)
    }()

    init(viewModel: SummaryPageViewModel,
         isFirstPage: Bool) {
        self.viewModel = viewModel
        self.contentView = .init(isFirstPage: isFirstPage)

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
}

extension SummaryPageController {
    private func configView() {
        contentView.summarySelectedAppsDashboardView.set(time: viewModel.output.getTime())
        contentView.otherAppsDashboardView.set(time: viewModel.output.getTime())
        add(controller: selectedAppsCollectionController,
            to: contentView.secondSectionFirstContentView)
        selectedAppsCollectionController.view.snp.makeConstraints({
            $0.height.equalTo(120)
        })
        add(controller: otherAppsTableViewController,
            to: contentView.fourthSectionFirstContentView)
    }
}
