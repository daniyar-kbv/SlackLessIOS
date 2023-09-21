//
//  CustomizeCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation

final class CustomizeCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let modulesFactory: CustomizeModulesFactory

    init(router: Router,
         modulesFactory: CustomizeModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeCustomizeModule()
        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
}
