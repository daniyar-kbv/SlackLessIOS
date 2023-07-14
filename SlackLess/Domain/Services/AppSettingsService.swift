//
//  AppSettingsService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import Foundation
import RxSwift
import RxCocoa
import FamilyControls

protocol AppSettingsServiceInput {
    func requestAuthorization()
    func set(timeLimit: TimeInterval)
    func set(onboardingShown: Bool)
    func set(selectedApps: FamilyActivitySelection)
}

protocol AppSettingsServiceOutput {
    var authorizaionStatus: PublishRelay<Result<Void, Error>> { get }
    var timeLimitSaved: PublishRelay<Void> { get }
    var appsSelectionSaved: PublishRelay<Void> { get }
    
    func getTimeLimit() -> TimeInterval?
    func getOnboardingShown() -> Bool
}

protocol AppSettingsService: AnyObject {
    var input: AppSettingsServiceInput { get }
    var output: AppSettingsServiceOutput { get }
}

final class AppSettingsServiceImpl: AppSettingsService, AppSettingsServiceInput, AppSettingsServiceOutput {
    var input: AppSettingsServiceInput { self }
    var output: AppSettingsServiceOutput { self }
    
    private let appSettingsRepository: AppSettingsRepository
    private let center = AuthorizationCenter.shared
    
    init(appSettingsRepository: AppSettingsRepository) {
        self.appSettingsRepository = appSettingsRepository
    }
    
    //    Output
    var authorizaionStatus: PublishRelay<Result<Void, Error>> = .init()
    var timeLimitSaved: PublishRelay<Void> = .init()
    var appsSelectionSaved: PublishRelay<Void> = .init()
    
    func getTimeLimit() -> Double? {
        appSettingsRepository.output.getTimeLimit()
    }
    
    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }
    
    //    Input
    
    func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
                DispatchQueue.main.async { [weak self] in
                    self?.authorizaionStatus.accept(.success(()))
                }
            } catch {
                authorizaionStatus.accept(.failure(DomainEmptyError()))
            }
        }
    }
    
    func set(timeLimit: TimeInterval) {
        appSettingsRepository.input.set(timeLimit: timeLimit)
        timeLimitSaved.accept(())
    }
    
    func set(selectedApps: FamilyActivitySelection) {
        appSettingsRepository.input.set(selectedApps: selectedApps)
        appsSelectionSaved.accept(())
    }
    
    func set(onboardingShown: Bool) {
        appSettingsRepository.input.set(onboardingShown: onboardingShown)
    }
}
