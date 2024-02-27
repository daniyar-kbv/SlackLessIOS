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

//    TODO: Change lazy var to let where needed

    private let appSettingsService: AppSettingsService
    private let pushNotificationsService: PushNotificationsService

    init(serviceFactory: ServiceFactory,
         appCoordinatorsFactory: ApplicationCoordinatorFactory,
         modulesFactory: ApplicationModulesFactory)
    {
        self.serviceFactory = serviceFactory
        self.appCoordinatorsFactory = appCoordinatorsFactory
        self.modulesFactory = modulesFactory
        
        appSettingsService = serviceFactory.makeAppSettingsService()
        pushNotificationsService = serviceFactory.makePushNotificationsService()

        super.init()
        
        bindPushNotificationService()
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
        
        pushNotificationsService.input.configure()
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

    func showWeeklyReportIfNeeded() {
        let service = serviceFactory.makeAppSettingsService()
        guard service.output.getShowWeeklyReport() else { return }
        let coordinator = appCoordinatorsFactory.makeWeeklyReportCoordinator()

        coordinator.didFinish.subscribe(onNext: { [weak self, weak service] in
            service?.input.setWeeklyReportShown()
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

//  MARK: Push Notifications

extension AppCoordinator {
    private func bindPushNotificationService() {
        pushNotificationsService.output.receivedNotification
            .subscribe(onNext: handle(notification:))
            .disposed(by: disposeBag)
        
        pushNotificationsService.output.errorOccured
            .subscribe(onNext: {
                UIApplication.shared.topViewController()?.showError($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func handle(notification: SLPushNotification) {
        switch notification.state {
        case .foreground:
            UIApplication.shared.topViewController()?
                .showAlert(title: notification.type.title,
                           message: notification.type.body,
                           submitTitle: SLTexts.Alert.Action.defaultTitle.localized()) { [weak self] in
                    self?.process(notificationType: notification.type)
                }
        case .background:
            process(notificationType: notification.type)
        }
    }
    
    private func process(notificationType: SLPushNotificationType) {
        print("Processing notification: \(notificationType)")
    }
}
