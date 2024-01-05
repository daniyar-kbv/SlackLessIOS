//
//  AppSettingsRepository.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-14.
//

import DeviceActivity
import FamilyControls
import Foundation
import RxCocoa
import RxSwift

protocol AppSettingsRepositoryInput {
    func set(onboardingShown: Bool)
    func set(currentSelectedApps: FamilyActivitySelection)
    func set(selectedApps: FamilyActivitySelection, for date: Date)
    func set(currentTimeLimit: TimeInterval)
    func set(timeLimit: TimeInterval, for date: Date)
    func set(unlockedTime: TimeInterval, for date: Date)
    func set(unlockPrice: Double)
    func set(startDate: Date)
    func set(progressDate: Date)
    func set(currentWeek: Date)
    func set(pushNotificationsEnabled: Bool)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getCurrentSelectedApps() -> FamilyActivitySelection?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getCurrentTimeLimit() -> TimeInterval
    func getTimeLimit(for date: Date) -> TimeInterval
    func getUnlockedTime(for date: Date) -> TimeInterval
    func getUnlockPrice() -> Double?
    func getIsLocked() -> Bool
    func getStartDate() -> Date?
    func getProgressDate() -> Date?
    func getCurrentWeek() -> Date?
    func getPushNotificationsEnabled() -> Bool

    var progressDateObservable: PublishRelay<Date?> { get }
    var isLockedObservable: PublishRelay<Bool> { get }
}

protocol AppSettingsRepository: AnyObject {
    var input: AppSettingsRepositoryInput { get }
    var output: AppSettingsRepositoryOutput { get }
}

//  TODO: Refactor to use right storage

final class AppSettingsRepositoryImpl: AppSettingsRepository, AppSettingsRepositoryInput, AppSettingsRepositoryOutput {
    var input: AppSettingsRepositoryInput { self }
    var output: AppSettingsRepositoryOutput { self }

    private let disposeBag = DisposeBag()
    private let keyValueStorage: KeyValueStorage

    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage

        bindStorage()
    }

    func bindStorage() {
        keyValueStorage
            .progressDateObservable
            .bind(to: progressDateObservable)
            .disposed(by: disposeBag)

        keyValueStorage
            .isLockedObservable
            .bind(to: isLockedObservable)
            .disposed(by: disposeBag)
    }

    //    Output
    let progressDateObservable: PublishRelay<Date?> = .init()
    let isLockedObservable: PublishRelay<Bool> = .init()

    func getOnboardingShown() -> Bool {
        keyValueStorage.onbardingShown
    }
    
    func getCurrentSelectedApps() -> FamilyActivitySelection? {
        keyValueStorage.getCurrentSelectedApps()
    }
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        keyValueStorage.getSelectedApps(for: date)
    }
    
    func getCurrentTimeLimit() -> TimeInterval {
        keyValueStorage.getCurrentTimeLimit()
    }

    func getTimeLimit(for date: Date) -> TimeInterval {
        keyValueStorage.getTimeLimit(for: date)
    }

    func getUnlockedTime(for date: Date) -> TimeInterval {
        keyValueStorage.getUnlockedTime(for: date)
    }

    func getUnlockPrice() -> Double? {
        let unlockPrice = keyValueStorage.unlockPrice
        guard unlockPrice > 0 else { return nil }
        return unlockPrice
    }

    func getIsLocked() -> Bool {
        keyValueStorage.isLocked
    }

    func getStartDate() -> Date? {
        keyValueStorage.startDate
    }

    func getProgressDate() -> Date? {
        keyValueStorage.progressDate
    }

    func getCurrentWeek() -> Date? {
        keyValueStorage.currentWeek
    }
    
    func getPushNotificationsEnabled() -> Bool {
        keyValueStorage.pushNotificationsEnabled
    }

    //    Input

    func set(onboardingShown: Bool) {
        keyValueStorage.persist(onbardingShown: onboardingShown)
    }
    
    func set(currentSelectedApps: FamilyActivitySelection) {
        keyValueStorage.persist(currentSelectedApps: currentSelectedApps)
    }

    func set(selectedApps: FamilyActivitySelection, for date: Date) {
        keyValueStorage.persist(selectedApps: selectedApps, for: date)
    }
    
    func set(currentTimeLimit: TimeInterval) {
        keyValueStorage.persist(currentTimeLimit: currentTimeLimit)
    }
    
    func set(timeLimit: TimeInterval, for date: Date) {
        keyValueStorage.persist(timeLimit: timeLimit, for: date)
    }

    func set(unlockedTime: TimeInterval, for date: Date) {
        keyValueStorage.persist(unlockedTime: unlockedTime, for: date)
    }

    func set(unlockPrice: Double) {
        keyValueStorage.persist(unlockPrice: unlockPrice)
    }

    func set(startDate: Date) {
        keyValueStorage.persist(startDate: startDate)
    }

    func set(progressDate: Date) {
        keyValueStorage.persist(progressDate: progressDate)
    }

    func set(currentWeek: Date) {
        keyValueStorage.persist(currentWeek: currentWeek)
    }
    
    func set(pushNotificationsEnabled: Bool) {
        keyValueStorage.persist(pushNotificationsEnabled: pushNotificationsEnabled)
    }
}
