//
//  AppDelegate.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import DeviceActivity
import IQKeyboardManagerSwift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let appComponentsFactory: AppComponentsFactory = AppComponentsFactoryImpl()
    private lazy var dataComponentsFactory = appComponentsFactory.makeDataComponenentsFactory()
    private lazy var domainComponentsFactory = appComponentsFactory.makeDomainComponentsFactory()
    private lazy var presentationComponentsFactory = appComponentsFactory.makePresentationComponentsFactory()
    private var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppCoordinator()
        configureKeyboardManager()
        startReachabilityManager()
        initializeServices()
        return true
    }

    private func makeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        //        TODO: remove
        window?.overrideUserInterfaceStyle = .light
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(
            serviceFactory: appComponentsFactory.makeDomainComponentsFactory().makeServiceFactory(),
            appCoordinatorsFactory: appComponentsFactory.makePresentationComponentsFactory().makeApplicationCoordinatorFactory(),
            modulesFactory: appComponentsFactory.makePresentationComponentsFactory().makeApplicationModulesFactory()
        )

        makeWindow()
        appCoordinator?.start()
    }

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = SLTexts.Keyboard.Toolbar.done.localized()
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.disabledToolbarClasses = []
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
    }

    private func startReachabilityManager() {
        let helpersFactory = appComponentsFactory.makeHelpersFactory()
        let reachabilityManager = helpersFactory.makeReachabilityManager()
        reachabilityManager.input.start()
    }

    private func initializeServices() {
        _ = domainComponentsFactory.makeServiceFactory().mameAppLockingService()
    }
}
