//
//  SetUpController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-22.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

// TODO: finish logic

final class SetUpController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SetUpViewModel
    private lazy var contentView = SetUpView()
    private lazy var settingsController = SLSettingsController(viewModel: viewModel.output.getSettingsViewModel())

    init(viewModel: SetUpViewModel) {
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
        bindView()
    }

    private func configureView() {
        add(controller: settingsController, to: contentView.settingsView)
    }

    private func bindView() {
        contentView.button.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.input.finish()
        })
        .disposed(by: disposeBag)
    }
}
