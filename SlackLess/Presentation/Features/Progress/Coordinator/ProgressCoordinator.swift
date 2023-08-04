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
    
    private let modulesFactory: ProgressModulesFactory

    init(router: Router,
         modulesFactory: ProgressModulesFactory) {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeProgressModule()
        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
}

