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
    func checkReset()
    func set(progressDate: Date)
    func setWeeklyReportShown()
}

protocol AppSettingsServiceOutput {
    var errorOccured: PublishRelay<ErrorPresentable> { get }

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

    init(appSettingsRepository: AppSettingsRepository,
         eventManager: EventManager)
    {
        self.appSettingsRepository = appSettingsRepository
        self.eventManager = eventManager
    }

    //    Output
    let errorOccured: PublishRelay<ErrorPresentable> = .init()

    func getIsLastDate(_ date: Date) -> Bool {
        guard let startDate = getStartDate()
        else { return true }
        return startDate.compareByDate(to: date) == .orderedSame
    }

    func getIsLastWeek(_ date: Date) -> Bool {
        guard let startDate = getStartDate()
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

    func checkReset() {
        guard let currentVersion = Bundle.main.version else { return }
        var resetVersions = appSettingsRepository.output.getResetVersions()
        
        guard Constants.Settings.resetVersions.keys.contains(currentVersion),
              !resetVersions.contains(currentVersion),
              let keys = Constants.Settings.resetVersions[currentVersion]
        else { return }
        
        appSettingsRepository.input.cleanKeyValueStorage(for: keys)
        resetVersions.append(currentVersion)
        appSettingsRepository.input.set(resetVersions: resetVersions)
    }

    func setWeeklyReportShown() {
        appSettingsRepository.input.set(currentWeek: Date().getFirstDayOfWeek())
    }

    func set(progressDate: Date) {
        appSettingsRepository.input.set(progressDate: progressDate)
    }
}

extension AppSettingsServiceImpl {
    func getStartDate() -> Date? {
        appSettingsRepository.output.getDayData().sorted(by: { $0.date < $1.date }).first?.date
    }
}
