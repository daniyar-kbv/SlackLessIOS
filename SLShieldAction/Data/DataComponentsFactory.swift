//
//  DataComponentsFactory.swift
//  SLShieldAction
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation

protocol DataComponentsFactory: AnyObject {
    func makeRepository() -> Repository
}

final class DataComponentsFactoryImpl: DependencyFactory, DataComponentsFactory {
    func makeRepository() -> Repository {
        shared(RepositoryImpl(keyValueStorage: makeKeyValueStorage()))
    }
    
    private func makeKeyValueStorage() -> KeyValueStorage {
        shared(KeyValueStorageImpl())
    }
}
