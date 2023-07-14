//
//  AppSettingsRepository.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-14.
//

import Foundation
import DeviceActivity
import FamilyControls

protocol AppSettingsRepositoryInput {
    func set(onboardingShown: Bool)
    func set(timeLimit: TimeInterval)
    func set(selectedApps: FamilyActivitySelection)
}

protocol AppSettingsRepositoryOutput {
    func getOnboardingShown() -> Bool
    func getTimeLimit() -> TimeInterval
    func getSelectedApps() -> FamilyActivitySelection?
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
    
    func getTimeLimit() -> TimeInterval {
        keyValueStorage.timelimit
    }
    
    func getSelectedApps() -> FamilyActivitySelection? {
        keyValueStorage.selectedApps
    }
    
    //    Input
    
    func set(onboardingShown: Bool) {
        keyValueStorage.persist(onbardingShown: onboardingShown)
    }
    
    func set(timeLimit: TimeInterval) {
        keyValueStorage.persist(timeLimit: timeLimit)
    }
    
    func set(selectedApps: FamilyActivitySelection) {
        keyValueStorage.persist(selectedApps: selectedApps)
    }
}
