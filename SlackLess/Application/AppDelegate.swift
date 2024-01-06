//
//  AppDelegate.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import DeviceActivity
import IQKeyboardManagerSwift
import UIKit
import FirebaseCore
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let appComponentsFactory: AppComponentsFactory = AppComponentsFactoryImpl()
    private lazy var dataComponentsFactory = appComponentsFactory.makeDataComponenentsFactory()
    private lazy var domainComponentsFactory = appComponentsFactory.makeDomainComponentsFactory()
    private lazy var presentationComponentsFactory = appComponentsFactory.makePresentationComponentsFactory()
    private var appCoordinator: AppCoordinator?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Uncomment to clean up
//        dataComponentsFactory.makeKeyValueStorage().cleanUp()
        
        configureFirebase()
        configureKeyboardManager()
        startReachabilityManager()
        initializeServices()
        configureAppCoordinator()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        appCoordinator?.showWeeklyReportIfNeeded()
    }
    
    private func configureFirebase() {
        FirebaseApp.configure()
    }

    private func makeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

//      TODO: remove
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
        _ = domainComponentsFactory.makeServiceFactory().makeLockService()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "SlackLess")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
