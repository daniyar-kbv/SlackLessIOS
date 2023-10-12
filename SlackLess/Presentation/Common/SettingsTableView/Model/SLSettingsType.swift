//
//  SLSettingsType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-27.
//

import Foundation

enum SLSettingsType {
    case setUp
    case full
    case display

    var sections: [SLSettingsSection] {
        switch self {
        case .full: return [.settings(self), .notifications, .feedback]
        case .setUp: return [.settings(self)]
        case .display: return [.settings(self)]
        }
    }
}
