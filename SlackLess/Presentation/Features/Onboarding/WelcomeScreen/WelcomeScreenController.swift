//
//  WelcomeScreenController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

final class WelcomeScreenController: UIViewController {
    private let contentView = WelcomeScreenView()
    private let viewModel: WelcomeScreenViewModel

    init(viewModel: WelcomeScreenViewModel) {
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
    }
}
