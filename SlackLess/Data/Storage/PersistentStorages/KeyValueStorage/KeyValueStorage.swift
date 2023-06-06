//
//  DefaultStorage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum KeyValueStorageKey: String, StorageKey, Equatable {
    case appLocale
    case notFirstLaunch

    var value: String { return rawValue }
}

protocol KeyValueStorage {
    var appLocale: Language { get }
    var notFirstLaunch: Bool { get }

    func persist(appLocale: Language)
    func persist(notFirstLaunch: Bool)

    func cleanUp(key: KeyValueStorageKey)
}

final class KeyValueStorageImpl: KeyValueStorage {
    private let storageProvider = UserDefaults.standard

    var notFirstLaunch: Bool {
        return storageProvider.bool(forKey: KeyValueStorageKey.notFirstLaunch.value)
    }

    var appLocale: Language {
        return Language.get(by: storageProvider.string(forKey: KeyValueStorageKey.appLocale.value))
    }

    func persist(appLocale: Language) {
        storageProvider.set(appLocale.code, forKey: KeyValueStorageKey.appLocale.value)
    }

    func persist(notFirstLaunch: Bool) {
        storageProvider.set(notFirstLaunch, forKey: KeyValueStorageKey.notFirstLaunch.value)
    }

    func cleanUp(key: KeyValueStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
}
