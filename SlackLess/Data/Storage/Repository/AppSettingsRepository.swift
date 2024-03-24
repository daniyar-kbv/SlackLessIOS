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
    func cleanKeyValueStorage(for keys: [KeyValueStorageKey])
    func set(resetVersions: [String])
    func set(onboardingShown: Bool)
    func set(dayData: DayData)
    func set(shield: SLShield?)
    func set(progressDate: Date)
    func set(currentWeek: Date)
    func set(pushNotificationsEnabled: Bool)
}

protocol AppSettingsRepositoryOutput {
    func getResetVersions() -> [String]
    func getOnboardingShown() -> Bool
    func getDayData() -> [DayData]
    func getDayData(for date: Date) -> DayData?
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
    
    func getResetVersions() -> [String] {
        keyValueStorage.resetVersions
    }

    func getOnboardingShown() -> Bool {
        keyValueStorage.onbardingShown
    }
    
    func getDayData() -> [DayData] {
        keyValueStorage.getDayData()
    }
    
    func getDayData(for date: Date) -> DayData? {
        keyValueStorage.getDayData(for: date)
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

    func cleanKeyValueStorage(for keys: [KeyValueStorageKey]) {
        keys.forEach({ keyValueStorage.cleanUp(key: $0) })
    }

    func set(resetVersions: [String]) {
        keyValueStorage.persist(resetVersions: resetVersions)
    }

    func set(onboardingShown: Bool) {
        keyValueStorage.persist(onbardingShown: onboardingShown)
    }

    func set(dayData: DayData) {
        keyValueStorage.persist(dayData: dayData)
    }
    
    func set(shield: SLShield?) {
        keyValueStorage.persist(shield: shield)
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
