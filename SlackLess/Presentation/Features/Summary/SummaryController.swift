//
//  SummaryController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import UIKit

final class SummaryController: UIViewController {
    private let viewModel: SummaryViewModel
    private let reportController: SLReportController
    
    private let disposeBag = DisposeBag()
    private let contentView = SummaryView()

    init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
        self.reportController = .init(viewModel: viewModel.output.getReportViewModel())
        
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
        contentView.set(title: SLTexts.Summary.title.localized())
        
        add(controller: reportController, to: contentView.reportView)
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

        viewModel.output.isntFirstDate.bind(to: contentView.dateSwitcherView.leftButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.output.isntLastDate.bind(to: contentView.dateSwitcherView.rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
