//
//  CustomizeController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class CustomizeController: UIViewController {
    private let viewModel: CustomizeViewModel

    private let disposeBag = DisposeBag()
    private lazy var contentView = CustomizeView()
    private lazy var settingsController = SLSettingsController(viewModel: viewModel.output.settingViewModel)

    init(viewModel: CustomizeViewModel) {
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
    }

    private func configureView() {
        contentView.set(title: SLTexts.Customize.title.localized())
        add(controller: settingsController, to: contentView.settingsView)
    }
}
