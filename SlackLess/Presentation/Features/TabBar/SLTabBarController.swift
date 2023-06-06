//
//  MainTabController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit

final class SLTabBarController: UITabBarController {
    private let viewModel: SLTabBarViewModel
    private var lastViewController: UIViewController?

    init(viewModel: SLTabBarViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        tabBar.isTranslucent = false
        tabBar.itemPositioning = .centered
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tabBar.isHidden = false
    }
}
