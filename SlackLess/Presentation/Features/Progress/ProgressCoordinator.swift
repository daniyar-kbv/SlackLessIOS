//
//  ProgressCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit

final class ProgressCoordinator: BaseCoordinator {
    private(set) var router: Router

    init(router: Router) {
        self.router = router
    }

    override func start() {
        var controller: UIViewController
        switch Constants.appMode {
        case .debug:
            controller = ProgressReportController(viewModel: ProgressReportViewModelImpl(weeks: MockData.getWeeks()))
        default:
            controller = SummaryController()
        }
        router.set(navigationController: SLNavigationController(rootViewController: controller))
    }
}

