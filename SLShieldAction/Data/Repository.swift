//
//  Repository.swift
//  SLShieldAction
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func getShield() -> SLShield?
    func set(shield: SLShield?)
    func getDayData(for date: Date) -> DayData?
    func set(dayData: DayData)
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getShield() -> SLShield? {
        keyValueStorage.shield
    }
    
    func set(shield: SLShield?) {
        keyValueStorage.persist(shield: shield)
    }
    
    func getDayData(for date: Date) -> DayData? {
        keyValueStorage.getDayData(for: date)
    }
    
    func set(dayData: DayData) {
        keyValueStorage.persist(dayData: dayData)
    }
}

