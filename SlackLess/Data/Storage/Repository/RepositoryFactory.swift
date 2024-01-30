//
//  RepositoryComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol RepositoryFactory: AnyObject {
    func makeAppSettingsRepository() -> AppSettingsRepository
    func makeTokensRepository() -> TokensRepository
}

final class RepositoryFactoryImpl: DependencyFactory, RepositoryFactory {
    private let cacheStorage: BaseCacheStorage
    private let keyValueStorage: KeyValueStorage
    private let secureStorage: SecureStorage
    
    init(cacheStorage: BaseCacheStorage,
         keyValueStorage: KeyValueStorage,
         secureStorage: SecureStorage) {
        self.cacheStorage = cacheStorage
        self.keyValueStorage = keyValueStorage
        self.secureStorage = secureStorage
    }
    
    func makeAppSettingsRepository() -> AppSettingsRepository {
        shared(AppSettingsRepositoryImpl(keyValueStorage: keyValueStorage))
    }
    
    func makeTokensRepository() -> TokensRepository {
        shared(TokensRepositoryImpl(keyValueStorage: keyValueStorage))
    }
}
