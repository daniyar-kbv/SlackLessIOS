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
    private let tabBarBarTypes: [SLTabBarType] = [.summary, .progress, .customize]

    private var preparedViewControllers: [UIViewController] = []

    private let serviceFactory: ServiceFactory

    private let appCoordinatorsFactory: ApplicationCoordinatorFactory
    private let modulesFactory: ApplicationModulesFactory

    private var disposeBag = DisposeBag()

    private lazy var appSettingsService = serviceFactory.makeAppSettingsService()

    init(serviceFactory: ServiceFactory,
         appCoordinatorsFactory: ApplicationCoordinatorFactory,
         modulesFactory: ApplicationModulesFactory)
    {
        self.serviceFactory = serviceFactory
        self.appCoordinatorsFactory = appCoordinatorsFactory
        self.modulesFactory = modulesFactory
    }

    override func start() {
        if appSettingsService.output.getOnboardingShown() {
            configureCoordinators()
            showTabBarController()
            showWeeklyReportIfNeeded()
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
        let coordinator = appCoordinatorsFactory.makeOnboardingCoordinator()

        coordinator.didFinish.subscribe(onNext: { [weak self] in
            self?.appSettingsService.input.set(onboardingShown: true)
            self?.start()
            self?.remove(coordinator)
        })
        .disposed(by: disposeBag)

        add(coordinator)
        coordinator.start()
    }

//    Uncomment to turn on weekly reports
    func showWeeklyReportIfNeeded() {
        let service = serviceFactory.makeAppSettingsService()
//        guard service.output.getShowWeeklyReport() else { return }
        let coordinator = appCoordinatorsFactory.makeWeeklyReportCoordinator()

        coordinator.didFinish.subscribe(onNext: { [weak self, weak service] in
//            service?.input.setWeeklyReportShown()
            self?.remove(coordinator)
        })
        .disposed(by: disposeBag)

        add(coordinator)
        coordinator.start()
    }
}

//  MARK: Coordinators configurations

extension AppCoordinator {
    private func configureCoordinators() {
        tabBarBarTypes.forEach { type in
            switch type {
            case .summary: configureSummaryCoordinator(tabBarItem: type.tabBarItem)
            case .progress: configureProgressCoordinator(tabBarItem: type.tabBarItem)
            case .customize: configureCustomizeCoordinator(tabBarItem: type.tabBarItem)
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

    private func configureCustomizeCoordinator(tabBarItem: UITabBarItem) {
        let coordinator = appCoordinatorsFactory.makeCustomizeCoordinator()

        coordinator.start()
        coordinator.router.getNavigationController().tabBarItem = tabBarItem

        preparedViewControllers.append(coordinator.router.getNavigationController())
        add(coordinator)
    }
}
