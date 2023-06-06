//
//  AppDelegate.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let appComponentsFactory: AppComponentsFactory = AppComponentsFactoryImpl()
    private let tester = Tester()
    private var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppCoordinator()
        configureKeyboardManager()
        configureLocalization()
        startReachabilityManager()

//        tester.runTests()

        return true
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(
            repositoryFactory: appComponentsFactory.makeRepositoryFactory(),
            serviceFactory: appComponentsFactory.makeServiceFactory(),
            appCoordinatorsFactory: appComponentsFactory.makeApplicationCoordinatorFactory(),
            modulesFactory: appComponentsFactory.makeApplicationModulesFactory(),
            helpersFactory: appComponentsFactory.makeHelpersFactory()
        )

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        appCoordinator?.start()
    }

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared.toolbarTintColor = SLColors.carbonGrey.getColor()
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = SLTexts.Keyboard.Toolbar.done.localized()
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.disabledToolbarClasses = []
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = []
    }

    private func configureLocalization() {
        Localization.keyValueStorage = appComponentsFactory.makeKeyValueStorage()
    }

    private func startReachabilityManager() {
        let helpersFactory = appComponentsFactory.makeHelpersFactory()
        let reachabilityManager = helpersFactory.makeReachabilityManager()
        reachabilityManager.input.start()
    }
}
