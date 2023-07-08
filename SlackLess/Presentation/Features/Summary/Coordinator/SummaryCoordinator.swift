//
//  SummaryCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit

final class SummaryCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let appStateManager: AppStateManager

    var didTerminate: (() -> Void)?
    var didFinish: (() -> Void)?

    init(router: Router,
         appStateManager: AppStateManager)
    {
        self.router = router
        self.appStateManager = appStateManager
    }

    override func start() {
        var controller: UIViewController
        switch appStateManager.output.getAppMode() {
        case .debug:
            controller = SummaryInnerController(viewModel: SummaryViewModelImpl())
        default:
            controller = SummaryController()
        }
        router.set(navigationController: SLNavigationController(rootViewController: controller))
    }
}
