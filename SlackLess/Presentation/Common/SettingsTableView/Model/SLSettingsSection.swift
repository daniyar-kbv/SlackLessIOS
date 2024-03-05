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
    
    var buttonTitle: String? {
        switch self {
        case .settings: return SLTexts.Settings.Settings.buttonTitle.localized()
        default: return nil
        }
    }
    
    var hideButton: Bool {
        switch self {
        case let .settings(type):
            switch type {
            case .full: return false
            default: return true
            }
        default: return true
        }
    }

    var items: [SLSettingsItem] {
        switch self {
        case .settings: return [.selectedApps, .timeLimit]
        case .notifications: return [.pushNotifications]
        case .feedback: return [.leaveFeedback]
        }
    }
}
