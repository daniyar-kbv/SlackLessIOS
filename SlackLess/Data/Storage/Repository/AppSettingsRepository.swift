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
    func set(timeLimit: TimeInterval, for date: Date)
    func set(selectedApps: FamilyActivitySelection, for date: Date)
    func set(unlockedTime: TimeInterval, for date: Date)
    func set(unlockPrice: Double)
    func set(isLocked: Bool)
    func set(startDate: Date)
    func set(progressDate: Date)
    func set(currentWeek: Date)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getTimeLimit(for date: Date) -> TimeInterval?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getUnlockedTime(for date: Date) -> TimeInterval
    func getUnlockPrice() -> Double?
    func getIsLocked() -> Bool
    func getStartDate() -> Date?
    func getProgressDate() -> Date?
    func getCurrentWeek() -> Date?

    var progressDateObservable: PublishRelay<Date?> { get }
    var isLockedObservable: PublishRelay<Bool> { get }
}

protocol AppSettingsRepository: AnyObject {
    var input: AppSettingsRepositoryInput { get }
    var output: AppSettingsRepositoryOutput { get }
}

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
    }

    //    Output
    let progressDateObservable: PublishRelay<Date?> = .init()
    let isLockedObservable: PublishRelay<Bool> = .init()

    func getOnboardingShown() -> Bool {
        keyValueStorage.onbardingShown
    }

    func getTimeLimit(for date: Date) -> TimeInterval? {
        let timeLimit = keyValueStorage.getTimeLimit(for: date)
        guard timeLimit > 0 else { return nil }
        return timeLimit
    }

    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        keyValueStorage.getSelectedApps(for: date)
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

    //    Input

    func set(onboardingShown: Bool) {
        keyValueStorage.persist(onbardingShown: onboardingShown)
    }

    func set(timeLimit: TimeInterval, for date: Date) {
        keyValueStorage.persist(timeLimit: timeLimit, for: date)
    }

    func set(selectedApps: FamilyActivitySelection, for date: Date) {
        keyValueStorage.persist(selectedApps: selectedApps, for: date)
    }

    func set(unlockedTime: TimeInterval, for date: Date) {
        keyValueStorage.persist(unlockedTime: unlockedTime, for: date)
    }

    func set(unlockPrice: Double) {
        keyValueStorage.persist(unlockPrice: unlockPrice)
    }

    func set(isLocked: Bool) {
        keyValueStorage.persist(isLocked: isLocked)
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
}
