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

//  TODO: Split into two services

protocol AppSettingsServiceInput {
    func requestAuthorization()
    func set(timeLimit: TimeInterval)
    func set(onboardingShown: Bool)
    func set(selectedApps: FamilyActivitySelection)
    func set(unlockPrice: Double)
    func set(progressDate: Date)
    func setWeeklyReportShown()
    func checkData(for date: Date)
    func checkData(forWeekOf date: Date)
}

protocol AppSettingsServiceOutput {
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var authorizaionStatus: PublishRelay<Result<Void, Error>> { get }
    var timeLimitSaved: PublishRelay<Void> { get }
    var appsSelectionSaved: PublishRelay<Void> { get }
    var isLocked: PublishRelay<Bool> { get }

    func getCurrentTimeLimit() -> TimeInterval?
    func getCurrentSelectedApps() -> FamilyActivitySelection?
    func getUnlockPrice() -> Double?
    func getIsLocked() -> Bool
    func getOnboardingShown() -> Bool
    func getIsLastDate(_ date: Date) -> Bool
    func getIsLastWeek(_ date: Date) -> Bool
    func getProgressDate() -> Date?
    func getShowWeeklyReport() -> Bool
}

protocol AppSettingsService: AnyObject {
    var input: AppSettingsServiceInput { get }
    var output: AppSettingsServiceOutput { get }
}

//  TODO: Add validation
//  TODO: Split into several services

final class AppSettingsServiceImpl: AppSettingsService, AppSettingsServiceInput, AppSettingsServiceOutput {
    var input: AppSettingsServiceInput { self }
    var output: AppSettingsServiceOutput { self }

    private let disposeBag = DisposeBag()
    private let appSettingsRepository: AppSettingsRepository
    private let eventManager: EventManager
    private let calendar = Calendar.current
    private var authorizationTimer: Timer?

    init(appSettingsRepository: AppSettingsRepository,
         eventManager: EventManager)
    {
        self.appSettingsRepository = appSettingsRepository
        self.eventManager = eventManager

        bindRepository()
        bindEventManager()
    }

    //    Output
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    let authorizaionStatus: PublishRelay<Result<Void, Error>> = .init()
    let timeLimitSaved: PublishRelay<Void> = .init()
    let appsSelectionSaved: PublishRelay<Void> = .init()
    let isLocked: PublishRelay<Bool> = .init()

    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }

    func getCurrentTimeLimit() -> Double? {
        appSettingsRepository.output.getCurrentTimeLimit()
    }

    func getCurrentSelectedApps() -> FamilyActivitySelection? {
        appSettingsRepository.output.getCurrentSelectedApps()
    }

    func getUnlockPrice() -> Double? {
        appSettingsRepository.output.getUnlockPrice()
    }

    func getIsLocked() -> Bool {
        appSettingsRepository.output.getIsLocked()
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

    func getShowWeeklyReport() -> Bool {
        let currentWeek = appSettingsRepository.output.getCurrentWeek() ?? Date().getFirstDayOfWeek()
        return !Date().getWeekInterval().containsDate(currentWeek)
    }

    //    Input

    func requestAuthorization() {
        authorizationTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [weak self] _ in
            self?.processAuthorizaztion(result: .success(()))
        }
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: FamilyControlsMember.individual)
                DispatchQueue.main.async { [weak self] in
                    self?.authorizationTimer?.invalidate()
                    self?.processAuthorizaztion(result: .success(()))
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.processAuthorizaztion(result: .failure(error))
                }
            }
        }
    }

    func setWeeklyReportShown() {
        appSettingsRepository.input.set(currentWeek: Date().getFirstDayOfWeek())
    }

    func set(selectedApps: FamilyActivitySelection) {
        appSettingsRepository.input.set(currentSelectedApps: selectedApps)
        appSettingsRepository.input.set(selectedApps: selectedApps, for: Date())
    }
    
    func set(timeLimit: TimeInterval) {
        appSettingsRepository.input.set(currentTimeLimit: timeLimit)
        appSettingsRepository.input.set(timeLimit: timeLimit, for: Date())
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
    
    func checkData(for date: Date) {
        guard appSettingsRepository.output.getSelectedApps(for: date) == nil,
              let currentSelectedApps = appSettingsRepository.output.getCurrentSelectedApps()
        else { return }
        
        appSettingsRepository.input.set(selectedApps: currentSelectedApps, for: date)
    }
    
    func checkData(forWeekOf date: Date) {
        for i in 0..<7 {
            checkData(for: date.getFirstDayOfWeek().add(.day, value: i))
        }
    }
}

extension AppSettingsServiceImpl {
    private func bindRepository() {
        appSettingsRepository.output.isLockedObservable
            .bind(to: isLocked)
            .disposed(by: disposeBag)
    }

    private func bindEventManager() {
        eventManager.subscribe(to: .updateLockFailed, disposeBag: disposeBag) { [weak self] in
            guard let error = $0 as? ErrorPresentable else { return }
            self?.errorOccured.accept(error)
        }
    }
}

extension AppSettingsServiceImpl {
    private func processAuthorizaztion(result: Result<Void, Error>) {
        switch result {
        case .success: appSettingsRepository.input.set(startDate: .now.getDate())
        case .failure: break
        }
        authorizaionStatus.accept(result)
    }
}
