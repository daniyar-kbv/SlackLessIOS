//
//  Repository.swift
//  SLShieldAction
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func getShieldState() -> SLShieldState?
    func set(shieldState: SLShieldState)
    func getUnlockedTime(for date: Date) -> TimeInterval
    func set(unlockedTime: TimeInterval, for date: Date)
    func getDayData(for date: Date) -> DayData?
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getShieldState() -> SLShieldState? {
        keyValueStorage.shieldState
    }
    
    func set(shieldState: SLShieldState) {
        keyValueStorage.persist(shieldState: shieldState)
    }
    
    func getUnlockedTime(for date: Date) -> TimeInterval {
        keyValueStorage.getUnlockedTime(for: date)
    }
    
    func set(unlockedTime: TimeInterval, for date: Date) {
        keyValueStorage.persist(unlockedTime: unlockedTime, for: date)
    }
    
    func getDayData(for date: Date) -> DayData? {
        keyValueStorage.getDayData(for: date)
    }
}

