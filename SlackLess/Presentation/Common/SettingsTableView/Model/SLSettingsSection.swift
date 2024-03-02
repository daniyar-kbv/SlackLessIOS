//
//  SLSettingsSection.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation

enum SLSettingsSection: Equatable {
    case settings(SLSettingsType)
    case notifications
    case feedback

    var title: String? {
        switch self {
        case .settings: return SLTexts.Settings.Settings.title.localized()
        case .notifications: return SLTexts.Settings.Notifications.title.localized()
        case .feedback: return SLTexts.Settings.Feedback.title.localized()
        }
    }

    var items: [SLSettingsItem] {
        switch self {
        case let .settings(type):
            switch type {
            case .full, .setUp: return [.selectedApps, .timeLimit]
            case .display: return [.timeLimit]
            }
        case .notifications: return [.pushNotifications]
        case .feedback: return [.leaveFeedback]
        }
    }
}
