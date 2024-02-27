//
//  Repository.swift
//  SLShieldConfiguration
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func getShield() -> SLShield?
    func getDayData() -> DayData?
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getShield() -> SLShield? {
        keyValueStorage.shield
    }
    
    func getDayData() -> DayData? {
        keyValueStorage.getDayData(for: Date().getDate())
    }
}

