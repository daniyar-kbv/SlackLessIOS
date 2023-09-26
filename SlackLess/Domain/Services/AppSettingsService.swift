//
//  AppSettingsService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import FamilyControls
import Foundation
import RxCocoa
import RxSwift

protocol AppSettingsServiceInput {
    func requestAuthorization()
    func set(timeLimit: TimeInterval)
    func set(onboardingShown: Bool)
    func set(selectedApps: FamilyActivitySelection)
    func set(unlockPrice: Double)
    func set(progressDate: Date)
}

protocol AppSettingsServiceOutput {
    var authorizaionStatus: PublishRelay<Result<Void, Error>> { get }
    var timeLimitSaved: PublishRelay<Void> { get }
    var appsSelectionSaved: PublishRelay<Void> { get }
    var selectionCategoryError: PublishRelay<DomainError> { get }
    var progressDateObservable: PublishRelay<Date?> { get }

    func getTimeLimit(for date: Date) -> TimeInterval?
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getUnlockPrice() -> Double?
    func getOnboardingShown() -> Bool
    func getIsLastDate(_ date: Date) -> Bool
    func getIsLastWeek(_ date: Date) -> Bool
    func getProgressDate() -> Date?
}

protocol AppSettingsService: AnyObject {
    var input: AppSettingsServiceInput { get }
    var output: AppSettingsServiceOutput { get }
}

//  TODO: Add validation

final class AppSettingsServiceImpl: AppSettingsService, AppSettingsServiceInput, AppSettingsServiceOutput {
    var input: AppSettingsServiceInput { self }
    var output: AppSettingsServiceOutput { self }

    private let disposeBag = DisposeBag()
    private let appSettingsRepository: AppSettingsRepository
    private let eventManager: EventManager
    private let authorizationCenter = AuthorizationCenter.shared
    private let calendar = Calendar.current

    init(appSettingsRepository: AppSettingsRepository,
         eventManager: EventManager)
    {
        self.appSettingsRepository = appSettingsRepository
        self.eventManager = eventManager

        bindRepository()
    }

    func bindRepository() {
        appSettingsRepository
            .output
            .progressDateObservable
            .bind(to: progressDateObservable)
            .disposed(by: disposeBag)
    }

    //    Output
    var authorizaionStatus: PublishRelay<Result<Void, Error>> = .init()
    var timeLimitSaved: PublishRelay<Void> = .init()
    var appsSelectionSaved: PublishRelay<Void> = .init()
    let selectionCategoryError: PublishRelay<DomainError> = .init()
    var progressDateObservable: PublishRelay<Date?> = .init()

    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }

    func getTimeLimit(for date: Date) -> Double? {
        if let timeLimit = appSettingsRepository.output.getTimeLimit(for: date) {
            return timeLimit
        }

        var timeLimit: TimeInterval?
        iterateThroughDays(startDate: date) { [weak self] in
            guard
                let self = self,
                let foundTimeLimit = appSettingsRepository.output.getTimeLimit(for: $0)
            else { return false }
            appSettingsRepository.input.set(timeLimit: foundTimeLimit, for: date)
            timeLimit = foundTimeLimit
            return true
        }

        return timeLimit
    }

    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        if let appsSelection = appSettingsRepository.output.getSelectedApps(for: date) {
            return appsSelection
        }

        var appsSelection: FamilyActivitySelection?
        iterateThroughDays(startDate: date) { [weak self] in
            guard
                let self = self,
                let foundAppsSelection = appSettingsRepository.output.getSelectedApps(for: $0)
            else { return false }
            appSettingsRepository.input.set(selectedApps: foundAppsSelection, for: date)
            appsSelection = foundAppsSelection
            return true
        }

        return appsSelection
    }

    func getUnlockPrice() -> Double? {
        appSettingsRepository.output.getUnlockPrice()
    }

    func getIsLastDate(_ date: Date) -> Bool {
        guard let startDate = appSettingsRepository.output.getStartDate()
        else { return true }
        return startDate.compareByDate(to: date) == .orderedSame
    }

    func getIsLastWeek(_ date: Date) -> Bool {
        guard let startDate = appSettingsRepository.output.getStartDate()
        else { return true }
        return startDate.getWeekInterval().containsDate(date)
    }

    func getProgressDate() -> Date? {
        appSettingsRepository.output.getProgressDate()
    }

    //    Input

    func requestAuthorization() {
        Task {
            do {
                try await authorizationCenter.requestAuthorization(for: FamilyControlsMember.individual)
                appSettingsRepository.input.set(startDate: .now.getDate())
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
        getWeek().forEach {
            appSettingsRepository.input.set(timeLimit: timeLimit, for: $0)
        }
        eventManager.send(event: .init(type: .appLimitSettingsChanged, value: ()))
        timeLimitSaved.accept(())
    }

    func set(selectedApps: FamilyActivitySelection) {
        guard selectedApps.categories.isEmpty,
              selectedApps.webDomains.isEmpty
        else {
            selectionCategoryError.accept(.categoriesNotAllowed)
            return
        }
        getWeek().forEach {
            appSettingsRepository.input.set(selectedApps: selectedApps, for: $0)
        }
        eventManager.send(event: .init(type: .appLimitSettingsChanged, value: ()))
        appsSelectionSaved.accept(())
    }

    func set(unlockPrice: Double) {
        guard unlockPrice > 0 else { return }
        appSettingsRepository.input.set(unlockPrice: unlockPrice)
    }

    func set(onboardingShown: Bool) {
        appSettingsRepository.input.set(onboardingShown: onboardingShown)
    }

    func set(progressDate: Date) {
        appSettingsRepository.input.set(progressDate: progressDate)
    }
}

extension AppSettingsServiceImpl {
    private func iterateThroughDays(startDate: Date, action: (Date) -> Bool) {
        var daysDifference = 0
        while daysDifference <= 100 {
            if action(startDate.add(.day, value: -daysDifference)) {
                break
            }
            daysDifference += 1
        }
    }

    private func getWeek() -> [Date] {
        var currentDate = Date().getDate()
        var days = [Date]()
        while currentDate != currentDate.getLastDayOfWeek() {
            days.append(currentDate)
            currentDate = currentDate.add(.day, value: 1)
        }
        return days
    }
}
