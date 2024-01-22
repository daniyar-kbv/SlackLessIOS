//
//  AuthTokenStorage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import KeychainAccess

protocol SecureStorage: AnyObject {
    var accessToken: String? { get }
    var refreshToken: String? { get }

    func persist(accessToken: String)
    func persist(refreshToken: String)
    func cleanUp()
}

enum SecureStorageKey: String, StorageKey, Equatable {
    case accessToken
    case refreshToken

    var value: String { return rawValue }
}

final class SecureStorageImpl: SecureStorage {
    // MARK: - Public Variables

    private let secureStorageProvider = Keychain()

    var accessToken: String? {
        return secureStorageProvider.getString(for: SecureStorageKey.accessToken)
    }

    var refreshToken: String? {
        return secureStorageProvider.getString(for: SecureStorageKey.refreshToken)
    }

    func persist(accessToken: String) {
        secureStorageProvider.set(accessToken, for: SecureStorageKey.accessToken)
    }

    func persist(refreshToken: String) {
        secureStorageProvider.set(refreshToken, for: SecureStorageKey.refreshToken)
    }

    func cleanUp() {
        let emptyValue: String? = nil
        secureStorageProvider.set(emptyValue, for: SecureStorageKey.accessToken)
        secureStorageProvider.set(emptyValue, for: SecureStorageKey.refreshToken)
    }
}
