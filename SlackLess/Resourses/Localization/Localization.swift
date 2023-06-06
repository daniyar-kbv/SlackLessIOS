//
//  LocalizationManager.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

final class Localization {
    static var keyValueStorage: KeyValueStorage?

    static func localized(key: String) -> String {
        guard let languageCode = keyValueStorage?.appLocale.code,
              let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path)
        else {
            return NSLocalizedString(key, tableName: "Localizable", comment: "")
        }

        return NSLocalizedString(key, tableName: "Localizable", bundle: bundle, comment: "")
    }

    static func localized(key: String, arguments: [String]) -> String {
        let localizedString = localized(key: key)

        return String(format: localizedString, arguments: arguments)
    }
}
