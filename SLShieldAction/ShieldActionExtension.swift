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
        guard let shield = repository.getShield() else { return }
        switch action {
        case .primaryButtonPressed:
            switch shield.state {
            case .remind: store.shield.applications = nil
            case .lock: completionHandler(.close)
            }
        case .secondaryButtonPressed:
            switch shield.state {
            case .remind:
                completionHandler(.defer)
            case .lock:
                store.shield.applications = nil
                
                let date = Date().getDate()
                guard let dayData = repository.getDayData(for: date) else { break }
                let unlockedTime = repository.getUnlockedTime(for: date) + SLLocker.shared.unlockTime
                
                repository.set(unlockedTime: unlockedTime, for: date)
                _ = SLLocker.shared.updateLock(dayData: dayData, delay: unlockedTime)
            }
            completionHandler(.defer)
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
