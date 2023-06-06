//
//  Storage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Cache
import Foundation

public final class BaseCacheStorage {
    private enum Keys: String {
        case disk
    }

    private func cache<T: Codable>(objectType _: T.Type) throws -> Cache.Storage<String, T> {
        let diskConfig = DiskConfig(name: Keys.disk.rawValue)
        let memoryConfig = MemoryConfig(expiry: .never,
                                        countLimit: 0,
                                        totalCostLimit: 0)
        return try Cache.Storage<String, T>(diskConfig: diskConfig,
                                            memoryConfig: memoryConfig,
                                            transformer: TransformerFactory.forCodable(ofType: T.self))
    }

    internal func save<T: Codable>(key: String, object: T?) {
        if let object = object {
            try? cache(objectType: T.self).setObject(object, forKey: key)
        } else {
            try? cache(objectType: T.self).removeObject(forKey: key)
        }
    }

    internal func get<T: Codable>(key: String) -> T? {
        try? cache(objectType: T.self).object(forKey: key)
    }
}
