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
    
    func getTimeLimit(for date: Date) -> TimeInterval?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
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
    
    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }
    
    func getTimeLimit(for date: Date) -> Double? {
        appSettingsRepository.output.getTimeLimit(for: date)
    }
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        appSettingsRepository.output.getSelectedApps(for: date)
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
                DispatchQueue.main.async { [weak self] in
                    self?.authorizaionStatus.accept(.failure(error))
                }
            }
        }
    }
    
    func set(timeLimit: TimeInterval) {
        getLastSevenDays().forEach({
            appSettingsRepository.input.set(timeLimit: timeLimit, for: $0)
        })
        timeLimitSaved.accept(())
    }
    
    func set(selectedApps: FamilyActivitySelection) {
        getLastSevenDays().forEach({
            appSettingsRepository.input.set(selectedApps: selectedApps, for: $0)
        })
        appsSelectionSaved.accept(())
    }
    
    func set(onboardingShown: Bool) {
        appSettingsRepository.input.set(onboardingShown: onboardingShown)
    }
}

extension AppSettingsServiceImpl {
    private func getLastSevenDays() -> [Date] {
        let today = Date()
        return (0..<7).map({
            Calendar.current.date(byAdding: .day, value: -$0, to: today)
        })
        .compactMap({ $0 })
    }
}
