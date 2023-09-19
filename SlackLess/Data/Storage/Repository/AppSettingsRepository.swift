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
    func set(startDate: Date)
    func set(progressDate: Date)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getTimeLimit(for date: Date) -> TimeInterval?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getStartDate() -> Date?
    func getProgressDate() -> Date?

    var progressDateObservable: PublishRelay<Date?> { get }
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
    var progressDateObservable: PublishRelay<Date?> = .init()

    func getOnboardingShown() -> Bool {
        keyValueStorage.onbardingShown
    }

    func getTimeLimit(for date: Date) -> TimeInterval? {
        let timeLimit = keyValueStorage.getTimeLimit(for: date)
        if timeLimit == 0 {
            return nil
        } else {
            return timeLimit
        }
    }

    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        keyValueStorage.getSelectedApps(for: date)
    }

    func getStartDate() -> Date? {
        keyValueStorage.startDate
    }

    func getProgressDate() -> Date? {
        keyValueStorage.progressDate
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

    func set(startDate: Date) {
        keyValueStorage.persist(startDate: startDate)
    }

    func set(progressDate: Date) {
        keyValueStorage.persist(progressDate: progressDate)
    }
}
