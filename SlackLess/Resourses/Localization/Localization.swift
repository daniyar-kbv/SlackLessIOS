//
//  Localization.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

final class Localization {
    static func localized(key: String) -> String {
        return NSLocalizedString(key, tableName: "Localizable", comment: "")
    }

    static func localized(key: String, arguments: [String]) -> String {
        let localizedString = localized(key: key)

        return String(format: localizedString, arguments: arguments)
    }
}
