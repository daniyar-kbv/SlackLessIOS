//
//  ProgressReportViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProgressReportViewModelInput {
    func set(weeks: [ARWeek])
    func changeDate(forward: Bool)
}

protocol ProgressReportViewModelOutput {
    var date: BehaviorRelay<String?> { get }
    var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> { get }
    var days: BehaviorRelay<[ARWeek.Day]> { get }
    var weeks: BehaviorRelay<[ARWeek]> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
}

protocol ProgressReportViewModel: AnyObject {
    var input: ProgressReportViewModelInput { get }
    var output: ProgressReportViewModelOutput { get }
}

final class ProgressReportViewModelImpl: ProgressReportViewModel,
                                         ProgressReportViewModelInput,
                                         ProgressReportViewModelOutput {
    var input: ProgressReportViewModelInput { self }
    var output: ProgressReportViewModelOutput { self }
    
    private var allWeeks: [ARWeek] {
        didSet {
            currentIndex = allWeeks.count - 1
        }
    }
    private lazy var currentIndex = allWeeks.count - 1
    
    init(weeks: [ARWeek]) {
        self.allWeeks = weeks
    }
    
    //    Output
    lazy var date: BehaviorRelay<String?> = .init(value: format(startDate: getCurrentWeek()?.startDate,
                                                               endDate: getCurrentWeek()?.startDate.getLastDayOfWeek()))
    lazy var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> = .init(value: (currentWeekTime: getCurrentWeek()?.getTime(),
                                                                                                       previousWeekTime: getPreviousWeek()?.getTime()))
    lazy var days: BehaviorRelay<[ARWeek.Day]> = .init(value: getCurrentWeek()?.days ?? [])
    lazy var weeks: BehaviorRelay<[ARWeek]> = .init(value: getFiveWeeks())
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: true)
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: false)
    
    //    Input
    func set(weeks: [ARWeek]) {
        self.allWeeks = weeks
        reload()
    }
    
    func changeDate(forward: Bool) {
        guard (forward && getIsntLastWeek()) || (!forward && getIsntFirstWeek()) else { return }
        currentIndex = currentIndex + (forward ? 1 : -1)
        reload()
    }
}

extension ProgressReportViewModelImpl {
    private func reload() {
        if let currentWeek = getCurrentWeek() {
            date.accept(format(startDate: currentWeek.startDate,
                               endDate: currentWeek.startDate.getLastDayOfWeek()))
            time.accept((currentWeekTime: currentWeek.getTime(),
                         previousWeekTime: getPreviousWeek()?.getTime()))
        }
        isntFirstDate.accept(getIsntFirstWeek())
        isntLastDate.accept(getIsntLastWeek())
        days.accept(getCurrentWeek()?.days ?? [])
        weeks.accept(getFiveWeeks())
    }
    
    private func getCurrentWeek() -> ARWeek? {
        guard !allWeeks.isEmpty else { return nil }
        return allWeeks[currentIndex]
    }
    
    private func getPreviousWeek() -> ARWeek? {
        guard getIsntFirstWeek() else { return nil }
        return allWeeks[currentIndex - 1]
    }
    
    private func getFiveWeeks() -> [ARWeek] {
        return allWeeks.suffix(5)
    }
    
    private func getIsntFirstWeek() -> Bool {
        currentIndex > 0
    }
    
    private func getIsntLastWeek() -> Bool {
        currentIndex < allWeeks.count - 1
    }
    
    private func format(startDate: Date?, endDate: Date?) -> String? {
        guard let startDate = startDate,
              let endDate = endDate
        else { return nil }
        return "\(startDate.formatted(style: .short)) - \(endDate.formatted(style: .short))"
    }
}

