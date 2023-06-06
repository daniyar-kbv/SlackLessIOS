//
//  Language.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum Language: String, CaseIterable {
    case english = "en"

    var code: String { rawValue }

    static func get(by code: String?) -> Language {
        return Language(rawValue: code ?? Language.english.code) ?? .english
    }
}
