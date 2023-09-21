//
//  SLSettingsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation

protocol SLSettingsViewModelInput {}

protocol SLSettingsViewModelOutput {
    func getNumberOfSections() -> Int
    func getNumberOfItems(in section: Int) -> Int
    func getTitle(for section: Int) -> String?
    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType
}

protocol SLSettingsViewModel: AnyObject {
    var input: SLSettingsViewModelInput { get }
    var output: SLSettingsViewModelOutput { get }
}

final class SLSettingsViewModelImpl: SLSettingsViewModel, SLSettingsViewModelInput, SLSettingsViewModelOutput {
    var input: SLSettingsViewModelInput { self }
    var output: SLSettingsViewModelOutput { self }

    private let type: SettingsType

    init(type: SettingsType) {
        self.type = type
    }

    //    Output
    func getNumberOfSections() -> Int {
        type.sections.count
    }

    func getNumberOfItems(in section: Int) -> Int {
        type.sections[section].cellTypes.count + 2
    }

    func getTitle(for section: Int) -> String? {
        type.sections[section].title
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        type.sections[indexPath.section].cellTypes[indexPath.item - 1]
    }

    //    Input
}

extension SLSettingsViewModelImpl {
    enum SettingsType {
        case appSettingsOnly
        case full

        var sections: [Section] {
            switch self {
            case .full: return [.settings, .notifications, .feedback]
            case .appSettingsOnly: return [.settings]
            }
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

        var cellTypes: [SLSettingsCell.CellType] {
            switch self {
            case .settings: return [.selectedApps, .timeLimit(10800), .unlockPrice(1)]
            case .notifications: return [.pushNotifications, .emails]
            case .feedback: return [.leaveFeedback]
            }
        }
    }
}
