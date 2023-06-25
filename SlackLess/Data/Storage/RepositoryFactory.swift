//
//  RepositoryComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol RepositoryFactory: AnyObject {
    func makeCacheStorage() -> BaseCacheStorage
    func makeKeyValueStorage() -> KeyValueStorage
    func makeSecureStorage() -> SecureStorage
}

final class RepositoryFactoryImpl: DependencyFactory, RepositoryFactory {
    public func makeCacheStorage() -> BaseCacheStorage {
        return shared(BaseCacheStorage())
    }

    public func makeKeyValueStorage() -> KeyValueStorage {
        return shared(KeyValueStorageImpl())
    }

    public func makeSecureStorage() -> SecureStorage {
        return shared(SecureStorageImpl())
    }
}
