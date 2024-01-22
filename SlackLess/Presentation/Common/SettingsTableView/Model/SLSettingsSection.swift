//
//  SLSettingsSection.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation

enum SLSettingsSection: Equatable {
    case settings(SLSettingsType)
    case purchases
    case notifications
    case feedback

    var title: String? {
        switch self {
        case .settings: return SLTexts.Settings.Settings.title.localized()
        case .purchases: return "PURCHASES"
        case .notifications: return SLTexts.Settings.Notifications.title.localized()
        case .feedback: return SLTexts.Settings.Feedback.title.localized()
        }
    }

    var items: [SLSettingsItem] {
        switch self {
        case let .settings(type):
            switch type {
            case .full, .setUp: return [.selectedApps, .timeLimit, .unlockPrice]
            case .display: return [.timeLimit, .unlockPrice]
            }
        case .purchases: return [.unlockTokens, .restorePurchases]
        case .notifications: return [.pushNotifications]
        case .feedback: return [.leaveFeedback]
        }
    }
}
