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
    func set(selectedApps: FamilyActivitySelection, timeLimit: TimeInterval, for date: Date)
    func set(unlockedTime: TimeInterval, for date: Date)
    func set(startDate: Date)
    func set(progressDate: Date)
    func set(currentWeek: Date)
    func set(pushNotificationsEnabled: Bool)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getDayData(for date: Date) -> DayData?
    func getUnlockedTime(for date: Date) -> TimeInterval
    func getStartDate() -> Date?
    func getProgressDate() -> Date?
    func getCurrentWeek() -> Date?
    func getPushNotificationsEnabled() -> Bool

    var progressDateObservable: PublishRelay<Date?> { get }
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
    }

    //    Output
    let progressDateObservable: PublishRelay<Date?> = .init()

    func getOnboardingShown() -> Bool {
        keyValueStorage.onbardingShown
    }
    
    func getDayData(for date: Date) -> DayData? {
        keyValueStorage.getDayData(for: date)
    }

    func getUnlockedTime(for date: Date) -> TimeInterval {
        keyValueStorage.getUnlockedTime(for: date)
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

    func set(selectedApps: FamilyActivitySelection, timeLimit: TimeInterval, for date: Date) {
        let dayData = DayData(date: date,
                              selectedApps: selectedApps,
                              timeLimit: timeLimit)
        keyValueStorage.persist(dayData: dayData)
    }

    func set(unlockedTime: TimeInterval, for date: Date) {
        keyValueStorage.persist(unlockedTime: unlockedTime, for: date)
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
