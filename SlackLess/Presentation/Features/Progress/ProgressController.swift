//
//  ProgressController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import UIKit

final class ProgressController: UIViewController {
    private let viewModel: ProgressViewModel
    private let reportController: SLReportController
    
    private let disposeBag = DisposeBag()
    private let contentView = ProgressView()

    init(viewModel: ProgressViewModel) {
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
        contentView.set(title: viewModel.output.getType().title)
        contentView.dateSwitcherView.isHidden = viewModel.output.getType().hideDateSwitcher
        contentView.button.isHidden = viewModel.output.getType().hideButton
        contentView.addTopOffset(viewModel.output.getType().addTopOffset)
        
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

        contentView.button.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.input.finish()
        })
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
