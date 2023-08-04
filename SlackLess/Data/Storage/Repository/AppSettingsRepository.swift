//
//  AppSettingsRepository.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-14.
//

import Foundation
import DeviceActivity
import FamilyControls
import RxSwift
import RxCocoa

protocol AppSettingsRepositoryInput {
    func set(onboardingShown: Bool)
    func set(timeLimit: TimeInterval, for date: Date)
    func set(selectedApps: FamilyActivitySelection, for date: Date)
    func set(startDate: Date)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getTimeLimit(for date: Date) -> TimeInterval?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getStartDate() -> Date?
}

protocol AppSettingsRepository: AnyObject {
    var input: AppSettingsRepositoryInput { get }
    var output: AppSettingsRepositoryOutput { get }
}

final class AppSettingsRepositoryImpl: AppSettingsRepository, AppSettingsRepositoryInput, AppSettingsRepositoryOutput {
    var input: AppSettingsRepositoryInput { self }
    var output: AppSettingsRepositoryOutput { self }
    
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    //    Output
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
}
