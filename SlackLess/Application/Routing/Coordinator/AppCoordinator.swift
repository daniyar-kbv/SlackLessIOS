//
//  AppCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class AppCoordinator: BaseCoordinator {
    private let tabBarBarTypes: [SLTabBarType] = [.summary]
    private var preparedViewControllers: [UIViewController] = []

    private let repositoryFactory: RepositoryFactory
    private let serviceFactory: ServiceFactory

    private let appCoordinatorsFactory: ApplicationCoordinatorFactory
    private let modulesFactory: ApplicationModulesFactory
    private let helpersFactory: HelpersFactory

    private var disposeBag = DisposeBag()

    private let eventManager: EventManager

    init(repositoryFactory: RepositoryFactory,
         serviceFactory: ServiceFactory,
         appCoordinatorsFactory: ApplicationCoordinatorFactory,
         modulesFactory: ApplicationModulesFactory,
         helpersFactory: HelpersFactory)
    {
        self.repositoryFactory = repositoryFactory
        self.serviceFactory = serviceFactory
        self.appCoordinatorsFactory = appCoordinatorsFactory
        self.modulesFactory = modulesFactory
        self.helpersFactory = helpersFactory
        eventManager = helpersFactory.makeEventManager()
    }

    override func start() {
        let keyValueStorage = repositoryFactory.makeKeyValueStorage()
        
        if keyValueStorage.onbardingShown {
            configureCoordinators()
            showTabBarController()
        } else {
            startOnboardingFlow()
        }
    }
}

//  MARK: Flow control

extension AppCoordinator {
    private func showTabBarController() {
        modulesFactory.makeSLTabBarController().viewControllers = preparedViewControllers

        UIApplication.shared.set(rootViewController: modulesFactory.makeSLTabBarController())
    }

    private func startOnboardingFlow() {
        let onBoardingCoordinator = appCoordinatorsFactory.makeOnboardingCoordinator()
        add(onBoardingCoordinator)
        onBoardingCoordinator.start()
    }
}

//  MARK: Coordinators configurations

extension AppCoordinator {
    private func configureCoordinators() {
        tabBarBarTypes.forEach { type in
            switch type {
            case .summary: configureSummaryCoordinator(tabBarItem: type.tabBarItem)
            }
        }
    }
    
    private func configureSummaryCoordinator(tabBarItem: UITabBarItem) {
        let coordinator = appCoordinatorsFactory.makeSummaryCoordinator()

        coordinator.start()
        coordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(coordinator.router.getNavigationController())
        add(coordinator)
    }
}
