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

    private let appInfoService: AppInfoService

    init(router: Router,
         appInfoService: AppInfoService) {
        self.router = router
        self.appInfoService = appInfoService
    }

    override func start() {
        var controller: UIViewController
        switch Constants.appMode {
        case .debug:
            controller = SummaryReportController(viewModel: SummaryReportViewModelImpl(appInfoService: appInfoService,
                                                                                       days: MockData.getDays(isRandom: false)))
        default:
            controller = SummaryController()
        }
        router.set(navigationController: SLNavigationController(rootViewController: controller))
    }
}
