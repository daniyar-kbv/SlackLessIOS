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
    var canChangeSettings: Bool { get }

    func getType() -> SLSettingsType
    func getNumberOfSections() -> Int
    func getNumberOfItems(in section: Int) -> Int
    func getTitle(for section: Int) -> String?
    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType
    func isSettings(section: Int) -> Bool
}

protocol SLSettingsViewModel: AnyObject {
    var input: SLSettingsViewModelInput { get }
    var output: SLSettingsViewModelOutput { get }
}

final class SLSettingsViewModelImpl: SLSettingsViewModel, SLSettingsViewModelInput, SLSettingsViewModelOutput {
    var input: SLSettingsViewModelInput { self }
    var output: SLSettingsViewModelOutput { self }

    private let type: SLSettingsType
    private let appSettingsService: AppSettingsService

    private lazy var appsSelection = appSettingsService.output.getSelectedApps(for: Date().getDate())
    private lazy var timeLimit = appSettingsService.output.getTimeLimit(for: Date().getDate())
    private lazy var unlockPrice = appSettingsService.output.getUnlockPrice()

    init(type: SLSettingsType,
         appSettingsService: AppSettingsService)
    {
        self.type = type
        self.appSettingsService = appSettingsService
    }

    //    Output
    var canChangeSettings: Bool {
        switch type {
        case .full: return false
        case .appSettingsOnly: return true
        }
    }

    func getType() -> SLSettingsType {
        type
    }

    func getNumberOfSections() -> Int {
        type.sections.count
    }

    func getNumberOfItems(in section: Int) -> Int {
        switch type {
        case .full: return type.sections[section].items.count + 2
        case .appSettingsOnly: return type.sections[section].items.count
        }
    }

    func getTitle(for section: Int) -> String? {
        type.sections[section].title
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        var index: Int?

        switch type {
        case .full: index = indexPath.item - 1
        case .appSettingsOnly: index = indexPath.item
        }

        switch type.sections[indexPath.section].items[index ?? 0] {
        case .selectedApps: return .selectedApps(appsSelection ?? .init())
        case .timeLimit: return .timeLimit(timeLimit)
        case .unlockPrice: return .unlockPrice(unlockPrice)
        case .pushNotifications: return .pushNotifications
        case .emails: return .emails
        case .leaveFeedback: return .leaveFeedback
        }
    }

    func isSettings(section: Int) -> Bool {
        type.sections[section] == .settings
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
