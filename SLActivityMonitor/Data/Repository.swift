//
//  Repository.swift
//  SLActivityMonitor
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func set(shieldState: SLShieldState)
    func getDayData(for date: Date) -> DayData?
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getDayData(for date: Date) -> DayData? {
        keyValueStorage.getDayData(for: date)
    }
    
    func set(shieldState: SLShieldState) {
        keyValueStorage.persist(shieldState: shieldState)
    }
}
