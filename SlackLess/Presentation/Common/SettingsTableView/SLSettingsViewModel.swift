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
    func set(unlockPrice: Double?)
    func selectUnlockTokens()
    func selectRestorePurchases()
    func set(pushNotificationsEnabled: Bool)
    func selectFeedback()
    func save()
}

protocol SLSettingsViewModelOutput {
    var reload: PublishRelay<Void> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var didSave: PublishRelay<Void> { get }
    var isComplete: BehaviorRelay<Bool> { get }
    var canChangeSettings: Bool { get }
    var pushNotificationsUnauthorized: PublishRelay<Void> { get }
    var unlockTokensSelected: PublishRelay<Void> { get }
    var feedbackSelected: PublishRelay<Void> { get }
    var iapAlert: PublishRelay<IAPManagerAlertType> { get }

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
    private let pushNotificationsService: PushNotificationsService?
    private let tokensService: TokensService

    private let disposeBag = DisposeBag()
    private lazy var appsSelection = appSettingsService.output.getCurrentSelectedApps()
    private lazy var timeLimit = appSettingsService.output.getCurrentTimeLimit()
    private lazy var unlockPrice = appSettingsService.output.getUnlockPrice()
    private var pushNotificationsEnabled = false

    init(type: SLSettingsType,
         appSettingsService: AppSettingsService,
         pushNotificationsService: PushNotificationsService?,
         tokensService: TokensService)
    {
        self.type = type
        self.appSettingsService = appSettingsService
        self.pushNotificationsService = pushNotificationsService
        self.tokensService = tokensService

        bindAppSettingsService()
        bindPushNotificationsService()
        
        tokensService.output.alert
            .subscribe(onNext: { [weak self] in
                self?.iapAlert.accept($0)
                self?.reload.accept(())
            })
            .disposed(by: disposeBag)
    }

    //    Output
    let reload: PublishRelay<Void> = .init()
    let didSave: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    lazy var isComplete: BehaviorRelay<Bool> = .init(value: getIsComplete())
    let pushNotificationsUnauthorized: PublishRelay<Void> = .init()
    let unlockTokensSelected: PublishRelay<Void> = .init()
    let feedbackSelected: PublishRelay<Void> = .init()
    let iapAlert: PublishRelay<IAPManagerAlertType> = .init()

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
        case .full, .display: return type.sections[section].items.count + 2
        case .setUp: return type.sections[section].items.count
        }
    }

    func getTitle(for section: Int) -> String? {
        type.sections[section].title
    }

    func getItemType(for indexPath: IndexPath) -> SLSettingsCell.CellType {
        var index: Int?

        switch type {
        case .full, .display: index = indexPath.item - 1
        case .setUp: index = indexPath.item
        }
        
        switch type.sections[indexPath.section].items[index ?? 0] {
        case .selectedApps: return .selectedApps(type, appsSelection ?? .init())
        case .timeLimit: return .timeLimit(type, timeLimit)
        case .unlockPrice: return .unlockPrice(type, unlockPrice)
        case .unlockTokens: return .unlockTokens(tokensService.output.getTokens())
        case .restorePurchases: return .restorePurchases
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

    func set(unlockPrice: Double?) {
        self.unlockPrice = unlockPrice
        isComplete.accept(getIsComplete())
    }
    
    func selectUnlockTokens() {
        unlockTokensSelected.accept(())
    }
    
    func selectRestorePurchases() {
        tokensService.input.restore()
    }
    
    func set(pushNotificationsEnabled: Bool) {
        pushNotificationsService?.input.set(pushNotificationsEnabled: pushNotificationsEnabled)
    }
    
    func save() {
        guard getIsComplete(),
              let appsSelection = appsSelection,
              let timeLimit = timeLimit,
              let unlockPrice = unlockPrice
        else { return }
        
        appSettingsService.input.set(selectedApps: appsSelection,
                                     timeLimit: timeLimit)
        appSettingsService.input.set(unlockPrice: unlockPrice)
        
        didSave.accept(())
    }
    
    func selectFeedback() {
        feedbackSelected.accept(())
    }
}

extension SLSettingsViewModelImpl {
    private func bindAppSettingsService() {
        appSettingsService.output.errorOccured
            .bind(to: errorOccured)
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
                || !(appsSelection?.categories.isEmpty ?? true)
                || !(appsSelection?.webDomains.isEmpty ?? true))
            )
            && !(timeLimit?.isZero ?? true)
            && !(unlockPrice?.isZero ?? true)
    }
}
