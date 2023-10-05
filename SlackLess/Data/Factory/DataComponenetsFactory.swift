//
//  DataComponenetsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-23.
//

import Foundation

protocol DataComponentsFactory: AnyObject {
    func makeAPIFactory() -> APIFactory
    func makeSecureStorage() -> SecureStorage
    func makeKeyValueStorage() -> KeyValueStorage
    func makeCacheStorage() -> BaseCacheStorage
    func makeRepositoryFactory() -> RepositoryFactory
}

final class DataComponenetsFactoryImpl: DependencyFactory, DataComponentsFactory {
    //    MARK: - Repository

    func makeRepositoryFactory() -> RepositoryFactory {
        return shared(RepositoryFactoryImpl(cacheStorage: makeCacheStorage(),
                                            keyValueStorage: makeKeyValueStorage(),
                                            secureStorage: makeSecureStorage()))
    }

    //    MARK: - Network

    func makeAPIFactory() -> APIFactory {
        return shared(APIFactoryImpl())
    }

    //    MARK: - Storage

    func makeSecureStorage() -> SecureStorage {
        return shared(SecureStorageImpl())
    }

    func makeKeyValueStorage() -> KeyValueStorage {
        return shared(KeyValueStorageImpl())
    }

    func makeCacheStorage() -> BaseCacheStorage {
        return shared(BaseCacheStorage())
    }
}
