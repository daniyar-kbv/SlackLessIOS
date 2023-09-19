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

    private let modulesFactory: SummaryModulesFactory

    init(router: Router,
         modulesFactory: SummaryModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeSummaryModule()
        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
}
