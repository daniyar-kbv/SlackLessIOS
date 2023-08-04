//
//  ProgressWeekReportViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProgressWeekReportViewModelInput {
    func set(weeks: [ARWeek])
}

protocol ProgressWeekReportViewModelOutput {
    var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> { get }
    var days: BehaviorRelay<[ARWeek.Day]> { get }
}

protocol ProgressWeekReportViewModel: AnyObject {
    var input: ProgressWeekReportViewModelInput { get }
    var output: ProgressWeekReportViewModelOutput { get }
}

final class ProgressWeekReportViewModelImpl: ProgressWeekReportViewModel,
                                         ProgressWeekReportViewModelInput,
                                         ProgressWeekReportViewModelOutput {
    var input: ProgressWeekReportViewModelInput { self }
    var output: ProgressWeekReportViewModelOutput { self }
    
    private var allWeeks: [ARWeek]
    
    init(weeks: [ARWeek]) {
        self.allWeeks = weeks
    }
    
    //    Output
    lazy var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> = .init(value: (currentWeekTime: getCurrentWeek()?.getTime(),
                                                                                                       previousWeekTime: getPreviousWeek()?.getTime()))
    lazy var days: BehaviorRelay<[ARWeek.Day]> = .init(value: getCurrentWeek()?.days ?? [])
    
    //    Input
    func set(weeks: [ARWeek]) {
        self.allWeeks = weeks
        reload()
    }
}

extension ProgressWeekReportViewModelImpl {
    private func reload() {
        time.accept((currentWeekTime: getCurrentWeek()?.getTime(),
                     previousWeekTime: getPreviousWeek()?.getTime()))
        days.accept(getCurrentWeek()?.days ?? [])
    }
    
    private func getCurrentWeek() -> ARWeek? {
        allWeeks.last
    }
    
    private func getPreviousWeek() -> ARWeek? {
        guard allWeeks.count > 1 else { return nil }
        return allWeeks.first
    }
}

