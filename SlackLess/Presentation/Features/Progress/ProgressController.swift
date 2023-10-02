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

final class ProgressController: SLReportsController {
    private let contentView = ProgressView()
    private let viewModel: ProgressViewModel

    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel

        super.init(reports: [.init(reportType: viewModel.output.getType().reportType, view: contentView.reportView)],
                   viewModel: viewModel)
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

        contentView.unlockButtonTap
            .subscribe(onNext: viewModel.input.unlock)
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

        viewModel.output.showUnlockButton
            .subscribe(onNext: { [weak self] in
                guard self?.viewModel.output.getType() == .normal else { return }
                self?.contentView.unlockButton.isHidden = !$0
            })
            .disposed(by: disposeBag)
    }
}
