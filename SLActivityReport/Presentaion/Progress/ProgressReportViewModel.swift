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
    var date: BehaviorRelay<String> { get }
    var time: BehaviorRelay<(currentWeekTime: ARTime, previousWeekTime: ARTime?)> { get }
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
    
    private var weeks: [ARWeek] {
        didSet {
            currentIndex = weeks.count - 1
        }
    }
    private lazy var currentIndex = weeks.count - 1
    
    init(weeks: [ARWeek]) {
        self.weeks = weeks
    }
    
    //    Output
    lazy var date: BehaviorRelay<String> = .init(value: format(startDate: getCurrentWeek().startDate,
                                                               endDate: getCurrentWeek().startDate.getLastDayOfWeek()))
    lazy var time: BehaviorRelay<(currentWeekTime: ARTime, previousWeekTime: ARTime?)> = .init(value: (currentWeekTime: getCurrentWeek().getTime(),
                                                                                                       previousWeekTime: getPreviousWeek()?.getTime()))
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: true)
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: false)
    
    //    Input
    func set(weeks: [ARWeek]) {
        self.weeks = weeks
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
        date.accept(format(startDate: getCurrentWeek().startDate,
                           endDate: getCurrentWeek().startDate.getLastDayOfWeek()))
        isntFirstDate.accept(getIsntFirstWeek())
        isntLastDate.accept(getIsntLastWeek())
        time.accept((currentWeekTime: getCurrentWeek().getTime(),
                     previousWeekTime: getPreviousWeek()?.getTime()))
    }
    
    private func getCurrentWeek() -> ARWeek {
        weeks[currentIndex]
    }
    
    private func getPreviousWeek() -> ARWeek? {
        guard getIsntFirstWeek() else { return nil }
        return weeks[currentIndex - 1]
    }
    
    private func getIsntFirstWeek() -> Bool {
        currentIndex > 0
    }
    
    private func getIsntLastWeek() -> Bool {
        currentIndex < weeks.count - 1
    }
    
    private func format(startDate: Date, endDate: Date) -> String {
        return "\(startDate.formatted(style: .short)) - \(endDate.formatted(style: .short))"
    }
}
