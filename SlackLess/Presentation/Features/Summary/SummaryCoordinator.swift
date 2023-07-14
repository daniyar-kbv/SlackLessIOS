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

    private let appSettingsService: AppSettingsService

    var didTerminate: (() -> Void)?
    var didFinish: (() -> Void)?

    init(router: Router,
         appSettingsService: AppSettingsService)
    {
        self.router = router
        self.appSettingsService = appSettingsService
    }

    override func start() {
        var controller: UIViewController
        switch Constants.appMode {
        case .debug:
            controller = ActivityReportSummaryController(viewModel: ActivityReportSummaryViewModelImpl(time: .init(slacked: 4800, total: 19500, limit: 10800)))
        default:
            controller = SummaryController()
        }
        router.set(navigationController: SLNavigationController(rootViewController: controller))
    }
}
