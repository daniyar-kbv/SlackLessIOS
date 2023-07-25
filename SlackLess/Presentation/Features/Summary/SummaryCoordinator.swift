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

    init(router: Router) {
        self.router = router
    }

    override func start() {
        var controller: UIViewController
        switch Constants.appMode {
        case .debug:
            controller = SummaryReportController(viewModel: SummaryReportViewModelImpl(days: MockData.getDays(isRandom: false)))
        default:
            controller = SummaryController()
        }
        router.set(navigationController: SLNavigationController(rootViewController: controller))
    }
}
