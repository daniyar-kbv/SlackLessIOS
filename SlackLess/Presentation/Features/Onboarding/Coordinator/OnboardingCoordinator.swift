//
//  OnboardingCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

final class OnboardingCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let modulesFactory: OnboardingModulesFactory

    var didTerminate: (() -> Void)?
    var didFinish: (() -> Void)?

    init(router: Router,
         modulesFactory: OnboardingModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeWelcomeScreenModule()

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
        router.getNavigationController().isNavigationBarHidden = true

        UIApplication.shared.set(rootViewController: router.getNavigationController())
    }
}
