//
//  RequestAuthController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class RequestAuthController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = RequestAuthView()
    private let viewModel: RequestAuthViewModel

    init(viewModel: RequestAuthViewModel) {
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

        bindView()
        bindViewModel()
    }

    private func bindView() {
        contentView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
                self?.viewModel.input.requestAuthorization()
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.output.authorizationComplete.subscribe(onNext: { [weak self] in
            self?.hideLoader()
        })
        .disposed(by: disposeBag)

        viewModel.output.gotError.subscribe(onNext: { [weak self] in
            self?.hideLoader()
            self?.showAlert(title: SLTexts.Alert.Error.title.localized(),
                            message: $0.presentationDescription,
                            actions: [
                                .init(
                                    title: SLTexts.Alert.Action.cancel.localized(),
                                    style: .cancel
                                ),
                                .init(
                                    title: SLTexts.Alert.Action.toSettings.localized(),
                                    style: .default,
                                    handler: { _ in
                                        guard let url = URL(string: UIApplication.openSettingsURLString),
                                              UIApplication.shared.canOpenURL(url)
                                        else { return }
                                        UIApplication.shared.open(url, options: [:])
                                    }
                                ),
                            ])
        })
        .disposed(by: disposeBag)
    }
}
