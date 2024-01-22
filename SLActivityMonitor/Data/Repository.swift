//
//  Repository.swift
//  SLActivityMonitor
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func set(isLocked: Bool)
    func set(shieldState: SLShieldState)
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        keyValueStorage.getDayData(for: date)?.selectedApps
    }
    
    func set(isLocked: Bool) {
        keyValueStorage.persist(isLocked: isLocked)
    }
    
    func set(shieldState: SLShieldState) {
        keyValueStorage.persist(shieldState: shieldState)
    }
}
