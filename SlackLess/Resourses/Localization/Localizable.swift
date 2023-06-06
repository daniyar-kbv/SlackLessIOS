//
//  UILocalizable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol Localizable {
    var rawValue: String { get }
    func localized() -> String
    func localized(_ arguments: String...) -> String
}

extension Localizable {
    func localized() -> String {
        return Localization.localized(key: rawValue)
    }

    func localized(_ arguments: String...) -> String {
        return Localization.localized(key: rawValue, arguments: arguments)
    }
}
