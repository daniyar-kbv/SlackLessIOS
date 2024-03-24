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

    func setWeeklyReportShown() {
        appSettingsRepository.input.set(currentWeek: Date().getFirstDayOfWeek())
    }

    func set(progressDate: Date) {
        appSettingsRepository.input.set(progressDate: progressDate)
    }
}
