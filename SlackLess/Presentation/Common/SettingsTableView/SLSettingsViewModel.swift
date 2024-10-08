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
    func load()
    func set(appSelection: FamilyActivitySelection)
    func set(timeLimit: TimeInterval?)
    func set(pushNotificationsEnabled: Bool)
    func modifySettings()
    func save()
    func selectFeedback()
}

protocol SLSettingsViewModelOutput {
    var reload: PublishRelay<Void> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var didSave: PublishRelay<Void> { get }
    var isComplete: BehaviorRelay<Bool> { get }
    var pushNotificationsUnauthorized: PublishRelay<Void> { get }
    var feedbackSelected: PublishRelay<Void> { get }
    var canChangeSettings: Bool { get }
    var startModifySettings: PublishRelay<Void> { get }

    func getType() -> SLSettingsType
    func getNumberOfSections() -> Int
    func getNumberOfItems(in section: Int) -> Int
    func getSection(for index: Int) -> SLSettingsSection?
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
    private let lockService: LockService
    private let pushNotificationsService: PushNotificationsService?

    private let disposeBag = DisposeBag()
    private lazy var appsSelection = lockService.output.getCurrentSelectedApps()
    private lazy var timeLimit = lockService.output.getCurrentTimeLimit()
    private var pushNotificationsEnabled = false

    init(type: SLSettingsType,
         lockService: LockService,
         pushNotificationsService: PushNotificationsService?)
    {
        self.type = type
        self.lockService = lockService
        self.pushNotificationsService = pushNotificationsService

        bindAppSettingsService()
        bindPushNotificationsService()
    }

    //    Output
    let reload: PublishRelay<Void> = .init()
    let didSave: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    lazy var isComplete: BehaviorRelay<Bool> = .init(value: getIsComplete())
    let pushNotificationsUnauthorized: PublishRelay<Void> = .init()
    let feedbackSelected: PublishRelay<Void> = .init()
    let startModifySettings: PublishRelay<Void> = .init()
    
    var canChangeSettings: Bool {
        switch type {
        case .full: return false
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
        case .setUp: return type.sections[section].items.count
        }
    }

    func getSection(for index: Int) -> SLSettingsSection? {
        guard index < type.sections.count else { return nil }
        return type.sections[index]
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        var index: Int?

        switch type {
        case .full: index = indexPath.item - 1
        case .setUp: index = indexPath.item
        }
        
        switch type.sections[indexPath.section].items[index ?? 0] {
        case .selectedApps: return .selectedApps(type, appsSelection ?? .init())
        case .timeLimit: return .timeLimit(type, timeLimit)
        case .pushNotifications: return .pushNotifications(pushNotificationsEnabled)
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
    func load() {
        pushNotificationsService?.input.getPushNotificationsEnabled()
    }
    
    func set(appSelection: FamilyActivitySelection) {
        self.appsSelection = appSelection
        isComplete.accept(getIsComplete())
    }

    func set(timeLimit: TimeInterval?) {
        self.timeLimit = timeLimit
        isComplete.accept(getIsComplete())
    }
    
    func set(pushNotificationsEnabled: Bool) {
        pushNotificationsService?.input.set(pushNotificationsEnabled: pushNotificationsEnabled)
    }
    
    func modifySettings() {
        startModifySettings.accept(())
    }
    
    func save() {
        guard getIsComplete(),
              let appsSelection = appsSelection,
              let timeLimit = timeLimit
        else { return }
        
        lockService.input.update(selectedApps: appsSelection,
                                 timeLimit: timeLimit)
        
        didSave.accept(())
    }
    
    func selectFeedback() {
        feedbackSelected.accept(())
    }
}

extension SLSettingsViewModelImpl {
    private func bindAppSettingsService() {
        lockService.output.errorOccured
            .bind(to: errorOccured)
            .disposed(by: disposeBag)
        
        lockService.output.dayDataSaved
            .subscribe(onNext: refreshData)
            .disposed(by: disposeBag)
    }
    
    private func bindPushNotificationsService() {
        pushNotificationsService?.output.errorOccured
            .bind(to: errorOccured)
            .disposed(by: disposeBag)
        
        pushNotificationsService?.output.pushNotificationEnabled
            .subscribe(onNext: { [weak self] in
                self?.pushNotificationsEnabled = $0
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
        
        pushNotificationsService?.output.pushNotificationsUnauthorized
            .bind(to: pushNotificationsUnauthorized)
            .disposed(by: disposeBag)
    }
    
    private func getIsComplete() -> Bool {
        return (
            Constants.Settings.environmentType == .simulator
            || (
                !(appsSelection?.applications.isEmpty ?? true)
                || !(appsSelection?.categories.isEmpty ?? true))
            )
            && !(timeLimit?.isZero ?? true)
    }
    
    private func refreshData() {
        appsSelection = lockService.output.getCurrentSelectedApps()
        timeLimit = lockService.output.getCurrentTimeLimit()
        reload.accept(())
    }
}
