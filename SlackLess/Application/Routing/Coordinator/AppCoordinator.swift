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
    private let tabBarBarTypes: [SLTabBarType] =
    Constants.appMode == .normal ?
    [.summary] :
    [.progress, .summary]
    
    private var preparedViewControllers: [UIViewController] = []

    private let repositoryFactory: RepositoryFactory
    private let serviceFactory: ServiceFactory

    private let appCoordinatorsFactory: ApplicationCoordinatorFactory
    private let modulesFactory: ApplicationModulesFactory
    private let helpersFactory: HelpersFactory

    private var disposeBag = DisposeBag()

    private lazy var appSettingsService = serviceFactory.makeAppSettingsService()

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
    }

    override func start() {
        if appSettingsService.output.getOnboardingShown() || Constants.appMode == .debug {
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
        
        onBoardingCoordinator.didFinish = { [weak self] in
            self?.appSettingsService.input.set(onboardingShown: true)
            self?.start()
        }
        
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
            case .progress: configureProgressCoordinator(tabBarItem: type.tabBarItem)
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
    
    private func configureProgressCoordinator(tabBarItem: UITabBarItem) {
        let coordinator = appCoordinatorsFactory.makeProgressCoordinator()

        coordinator.start()
        coordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(coordinator.router.getNavigationController())
        add(coordinator)
    }
}
