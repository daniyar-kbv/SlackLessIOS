//
//  DefaultStorage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import FamilyControls

enum KeyValueStorageKey: String, StorageKey, Equatable {
    case appLocale
    case notFirstLaunch
    case selectedApps
    case timeLimit

    public var value: String { return rawValue }
}

protocol KeyValueStorage {
    var appLocale: Language { get }
    var notFirstLaunch: Bool { get }
    var selectedApps: FamilyActivitySelection? { get }
    var timelimit: Double { get }

    func persist(appLocale: Language)
    func persist(notFirstLaunch: Bool)
    func persist(selectedApps: FamilyActivitySelection)
    func persist(timeLimit: Double)

    func cleanUp(key: KeyValueStorageKey)
}

final class KeyValueStorageImpl: KeyValueStorage {
    private let storageProvider = UserDefaults.standard
    private let decoder = PropertyListDecoder()

    public init() {}
    
    public var notFirstLaunch: Bool {
        return storageProvider.bool(forKey: KeyValueStorageKey.notFirstLaunch.value)
    }

    public var appLocale: Language {
        return Language.get(by: storageProvider.string(forKey: KeyValueStorageKey.appLocale.value))
    }
    
    public var selectedApps: FamilyActivitySelection? {
        guard let defaults = UserDefaults(suiteName: Constants.UserDefaults.SuiteName.main),
              let data = defaults.data(forKey: KeyValueStorageKey.selectedApps.value)
        else { return nil }
        
        let object = try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
        
        return object
    }
    
    public var timelimit: Double {
        storageProvider.double(forKey: KeyValueStorageKey.timeLimit.value)
    }

    public func persist(appLocale: Language) {
        storageProvider.set(appLocale.code, forKey: KeyValueStorageKey.appLocale.value)
    }

    public func persist(notFirstLaunch: Bool) {
        storageProvider.set(notFirstLaunch, forKey: KeyValueStorageKey.notFirstLaunch.value)
    }
    
    public func persist(selectedApps: FamilyActivitySelection) {
        guard let defaults = UserDefaults(suiteName: Constants.UserDefaults.SuiteName.main) else { return }
        let encoder = PropertyListEncoder()

        defaults.set(
            try? encoder.encode(selectedApps),
            forKey: KeyValueStorageKey.selectedApps.value
        )
    }
    
    public func persist(timeLimit: Double) {
        storageProvider.set(timeLimit, forKey: KeyValueStorageKey.timeLimit.value)
    }

    public func cleanUp(key: KeyValueStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
}
