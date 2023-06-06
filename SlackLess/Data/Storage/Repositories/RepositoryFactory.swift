//
//  RepositoryComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol RepositoryFactory: AnyObject {}

final class RepositoryFactoryImpl: DependencyFactory, RepositoryFactory {}

extension RepositoryFactoryImpl {
    private func makeCacheStorage() -> BaseCacheStorage {
        return shared(BaseCacheStorage())
    }

    private func makeKeyValueStorage() -> KeyValueStorage {
        return shared(KeyValueStorageImpl())
    }

    private func makeSecureStorage() -> SecureStorage {
        return shared(SecureStorageImpl())
    }
}
