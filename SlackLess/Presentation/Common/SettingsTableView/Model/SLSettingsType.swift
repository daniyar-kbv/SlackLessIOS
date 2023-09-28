//
//  SLSettingsType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-27.
//

import Foundation

enum SLSettingsType {
    case appSettingsOnly
    case full

    var sections: [Section] {
        switch self {
        case .full: return [.settings, .notifications, .feedback]
        case .appSettingsOnly: return [.settings]
        }
    }

    enum Section: Int {
        case settings
        case notifications
        case feedback

        var title: String? {
            switch self {
            case .settings: return SLTexts.Settings.Settings.title.localized()
            case .notifications: return SLTexts.Settings.Notifications.title.localized()
            case .feedback: return SLTexts.Settings.Feedback.title.localized()
            }
        }

        var items: [Item] {
            switch self {
            case .settings: return [.selectedApps, .timeLimit, .unlockPrice]
            case .notifications: return [.pushNotifications, .emails]
            case .feedback: return [.leaveFeedback]
            }
        }

        enum Item {
            case selectedApps
            case timeLimit
            case unlockPrice
            case pushNotifications
            case emails
            case leaveFeedback
        }
    }
}
