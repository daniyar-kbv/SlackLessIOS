//
//  UnlockController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-29.
//

import Foundation
import PassKit
import RxCocoa
import RxSwift
import UIKit

final class UnlockController: UIViewController {
    private let viewModel: UnlockViewModel

    private let disposeBag = DisposeBag()
    private lazy var contentView = UnlockView()

    init(viewModel: UnlockViewModel) {
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

        configureView()
        bindViewModel()
    }

    private func configureView() {
        contentView.set(title: SLTexts.Unlock.title.localized())
    }

    private func bindViewModel() {
        viewModel.output.applePayStatus
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                contentView.setUpApplePayButton(for: $0)?
                    .rx.tap
                    .subscribe(onNext: handleApplePayButtonTap)
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)

        viewModel.output.unlockSucceed
            .subscribe(onNext: { [weak self] in
                self?.showAlert(title: SLTexts.Unlock.Alert.Success.title.localized(),
                                message: SLTexts.Unlock.Alert.Success.message.localized(),
                                submitTitle: SLTexts.Alert.Action.defaultTitle.localized(),
                                completion: nil)
            })
            .disposed(by: disposeBag)

        viewModel.output.errorOccured
            .subscribe(onNext: { [weak self] in
                self?.showError($0)
            })
            .disposed(by: disposeBag)
    }
}

extension UnlockController {
    private func handleApplePayButtonTap() {
        switch viewModel.output.applePayStatus.value {
        case .pay:
            viewModel.input.startPayment()
        case .setUp:
            PKPassLibrary().openPaymentSetup()
        case .failure:
            break
        }
    }
}
