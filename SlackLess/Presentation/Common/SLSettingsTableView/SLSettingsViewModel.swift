//
//  SLSettingsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import FamilyControls
import Foundation

protocol SLSettingsViewModelInput {
    func set(appSelection: FamilyActivitySelection)
    func set(timeLimit: TimeInterval?)
    func set(unlockPrice: Double?)
}

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
    private let appSettingsService: AppSettingsService

    private lazy var appsSelection = appSettingsService.output.getSelectedApps(for: Date().getDate())
    private lazy var timeLimit = appSettingsService.output.getTimeLimit(for: Date().getDate())
    private lazy var unlockPrice = appSettingsService.output.getUnlockPrice()

    init(type: SettingsType,
         appSettingsService: AppSettingsService)
    {
        self.type = type
        self.appSettingsService = appSettingsService
    }

    //    Output
    func getNumberOfSections() -> Int {
        type.sections.count
    }

    func getNumberOfItems(in section: Int) -> Int {
        type.sections[section].items.count + 2
    }

    func getTitle(for section: Int) -> String? {
        type.sections[section].title
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        switch type.sections[indexPath.section].items[indexPath.item - 1] {
        case .selectedApps: return .selectedApps(appsSelection ?? .init())
        case .timeLimit: return .timeLimit(timeLimit)
        case .unlockPrice: return .unlockPrice(unlockPrice)
        case .pushNotifications: return .pushNotifications
        case .emails: return .emails
        case .leaveFeedback: return .leaveFeedback
        }
    }

    //    Input
    func set(appSelection: FamilyActivitySelection) {
        guard !appSelection.applicationTokens.isEmpty &&
            !appSelection.categoryTokens.isEmpty &&
            !appSelection.webDomainTokens.isEmpty
        else { return }
        appSettingsService.input.set(selectedApps: appSelection)
    }

    func set(timeLimit: TimeInterval?) {
        guard let timeLimit = timeLimit else { return }
        appSettingsService.input.set(timeLimit: timeLimit)
    }

    func set(unlockPrice: Double?) {
        guard let unlockPrice = unlockPrice else { return }
        appSettingsService.input.set(unlockPrice: unlockPrice)
    }
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
