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
    var selectionCategoryError: PublishRelay<DomainError> { get }
    
    func getTimeLimit(for date: Date) -> TimeInterval
    func getSelectedApps(for date: Date) -> FamilyActivitySelection
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
    let selectionCategoryError: PublishRelay<DomainError> = .init()
    
    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }
    
    func getTimeLimit(for date: Date) -> Double {
        if let timeLimit = appSettingsRepository.output.getTimeLimit(for: date) {
            return timeLimit
        }
        let daysDifference = 0
        while true {
            if let oldDate = Calendar.current.date(byAdding: .day, value: -daysDifference, to: date),
               let timeLimit = appSettingsRepository.output.getTimeLimit(for: oldDate) {
                appSettingsRepository.input.set(timeLimit: timeLimit, for: date)
                return timeLimit
            }
        }
    }
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection {
        if let appsSelection = appSettingsRepository.output.getSelectedApps(for: date) {
            return appsSelection
        }
        let daysDifference = 0
        while true {
            if let oldDate = Calendar.current.date(byAdding: .day, value: -daysDifference, to: date),
               let appsSelection = appSettingsRepository.output.getSelectedApps(for: oldDate) {
                appSettingsRepository.input.set(selectedApps: appsSelection, for: date)
                return appsSelection
            }
        }
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
        getWeek().forEach({
            appSettingsRepository.input.set(timeLimit: timeLimit, for: $0)
        })
        timeLimitSaved.accept(())
    }
    
    func set(selectedApps: FamilyActivitySelection) {
        guard selectedApps.categories.isEmpty else {
            selectionCategoryError.accept(.categoriesNotAllowed)
            return
        }
        getWeek().forEach({
            appSettingsRepository.input.set(selectedApps: selectedApps, for: $0)
        })
        appsSelectionSaved.accept(())
    }
    
    func set(onboardingShown: Bool) {
        appSettingsRepository.input.set(onboardingShown: onboardingShown)
    }
}

extension AppSettingsServiceImpl {
    private func getWeek() -> [Date] {
        var days = [Date]()
        for i in (0..<100) {
            let today = Date()
            guard let date = Calendar.current.date(byAdding: .day, value: i, to: today.getFirstDayOfWeek()) else { break }
            days.append(date)
            if date == today.getLastDayOfWeek() {
                break
            }
        }
        return days
    }
}
