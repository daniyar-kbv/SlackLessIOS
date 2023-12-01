//
//  Repository.swift
//  SLShieldAction
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls

protocol Repository: AnyObject {
    func getShieldState() -> SLShieldState
    func set(shieldState: SLShieldState)
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getShieldState() -> SLShieldState {
        keyValueStorage.shieldState
    }
    
    func set(shieldState: SLShieldState) {
        keyValueStorage.persist(shieldState: shieldState)
    }
}

