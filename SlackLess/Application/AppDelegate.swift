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
    private var appMode: Constants.AppMode = .experimental
    
    var window: UIWindow?

    private let appComponentsFactory: AppComponentsFactory = AppComponentsFactoryImpl()
    private var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        switch appMode {
        case .normal:
            configureAppCoordinator()
            configureKeyboardManager()
            configureLocalization()
            startReachabilityManager()
        case .experimental:
            makeWindow()
            ExperimentManager.shared.run()
        }
        
        return true
    }
    
    private func makeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(
            repositoryFactory: appComponentsFactory.makeRepositoryFactory(),
            serviceFactory: appComponentsFactory.makeServiceFactory(),
            appCoordinatorsFactory: appComponentsFactory.makeApplicationCoordinatorFactory(),
            modulesFactory: appComponentsFactory.makeApplicationModulesFactory(),
            helpersFactory: appComponentsFactory.makeHelpersFactory()
        )
        
        makeWindow()
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
