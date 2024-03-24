//
//  ShieldActionExtension.swift
//  SLShieldAction
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import ManagedSettings
import WebKit

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    private let dataComponentsFactory: DataComponentsFactory = DataComponentsFactoryImpl()
    private lazy var repository: Repository = dataComponentsFactory.makeRepository()
    private let store = ManagedSettingsStore()
    
    override func handle(action: ShieldAction, for _: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        guard let shield = repository.getShield() else {
            completionHandler(.close)
            return
        }
        
        switch action {
        case .primaryButtonPressed:
            switch shield.state {
            case .remind:
                store.shield.applications = nil
                completionHandler(.defer)
            case .lock:
                completionHandler(.close)
            }
        case .secondaryButtonPressed:
            switch shield.state {
            case .remind:
                completionHandler(.defer)
            case .lock:
//                TODO: Refactor to optimize fetching DayData
                guard var dayData = repository.getDayData(for: Date().getDate()) else {
                    completionHandler(.defer)
                    return
                }
                
                store.shield.applications = nil
                
                dayData.unlocks += 1
                repository.set(dayData: dayData)
                _ = SLLocker.shared.updateLock(dayData: dayData)
                
                completionHandler(.defer)
            }
        @unknown default:
            fatalError()
        }
    }

    override func handle(action _: ShieldAction, for _: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }

    override func handle(action _: ShieldAction, for _: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
}
