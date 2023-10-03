//
//  SLSettingsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import FamilyControls
import Foundation
import RxCocoa
import RxSwift

protocol SLSettingsViewModelInput {
    func set(appSelection: FamilyActivitySelection)
    func set(timeLimit: TimeInterval?)
    func set(unlockPrice: Double?)
}

protocol SLSettingsViewModelOutput {
    var errorOccured: PublishRelay<ErrorPresentable> { get }
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

    private let disposeBag = DisposeBag()
    private lazy var appsSelection = appSettingsService.output.getSelectedApps(for: Date().getDate())
    private lazy var timeLimit = appSettingsService.output.getTimeLimit(for: Date().getDate())
    private lazy var unlockPrice = appSettingsService.output.getUnlockPrice()

    init(type: SLSettingsType,
         appSettingsService: AppSettingsService)
    {
        self.type = type
        self.appSettingsService = appSettingsService

        bindService()
    }

    //    Output
    let errorOccured: PublishRelay<ErrorPresentable> = .init()

    var canChangeSettings: Bool {
        switch type {
        case .full, .display: return false
        case .setUp: return true
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
        case .setUp, .display: return type.sections[section].items.count
        }
    }

    func getTitle(for section: Int) -> String? {
        type.sections[section].title
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        var index: Int?

        switch type {
        case .full: index = indexPath.item - 1
        case .setUp, .display: index = indexPath.item
        }

        switch type.sections[indexPath.section].items[index ?? 0] {
        case .selectedApps: return .selectedApps(type, appsSelection ?? .init())
        case .timeLimit: return .timeLimit(type, timeLimit)
        case .unlockPrice: return .unlockPrice(type, unlockPrice)
        case .pushNotifications: return .pushNotifications
        case .emails: return .emails
        case .leaveFeedback: return .leaveFeedback
        }
    }

    func isSettings(section: Int) -> Bool {
        switch type.sections[section] {
        case .settings: return true
        default: return false
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
    private func bindService() {
        appSettingsService.output.errorOccured
            .bind(to: errorOccured)
            .disposed(by: disposeBag)
    }
}
