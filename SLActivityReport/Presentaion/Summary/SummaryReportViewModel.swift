//
//  SummaryReportViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation
import RxSwift
import RxCocoa

protocol SummaryReportViewModelInput {
    func changeDate(forward: Bool, fromDateSwitcher: Bool)
}

protocol SummaryReportViewModelOutput {
    var date: BehaviorRelay<String> { get }
    var isFirstDate: BehaviorRelay<Bool> { get }
    var isLastDate: BehaviorRelay<Bool> { get }
    var dateChangedForward: PublishRelay<Bool> { get }
    
    func getDays() -> [ActivityReportDay]
}

protocol SummaryReportViewModel: AnyObject {
    var input: SummaryReportViewModelInput { get }
    var output: SummaryReportViewModelOutput { get }
}

final class SummaryReportViewModelImpl: SummaryReportViewModel, SummaryReportViewModelInput, SummaryReportViewModelOutput {
    var input: SummaryReportViewModelInput { self }
    var output: SummaryReportViewModelOutput { self }
    
    private let days: [ActivityReportDay]
    private lazy var currentIndex = days.count - 1
    
    init(days: [ActivityReportDay]) {
        self.days = days
        
        days.forEach({
            print($0.date)
        })
    }
    
    //    Output
    lazy var date: BehaviorRelay<String> = .init(value: format(date: Date()))
    lazy var isFirstDate: BehaviorRelay<Bool> = .init(value: false)
    lazy var isLastDate: BehaviorRelay<Bool> = .init(value: true)
    lazy var dateChangedForward: PublishRelay<Bool> = .init()
    
    func getDays() -> [ActivityReportDay] {
        return days
    }
    
    func changeDate(forward: Bool, fromDateSwitcher: Bool) {
        guard (forward && !isLastDay()) || (!forward && !isFirstDay()) else { return }
        currentIndex = currentIndex + (forward ? 1 : -1)
        isFirstDate.accept(isFirstDay())
        isLastDate.accept(isLastDay())
        let newDay = days[currentIndex]
        date.accept(format(date: newDay.date))
        if fromDateSwitcher {
            dateChangedForward.accept(forward)
        }
    }
    
    //    Input
    
}

extension SummaryReportViewModelImpl {
    private func isFirstDay() -> Bool {
        currentIndex - 1 < 0
    }
    
    private func isLastDay() -> Bool {
        currentIndex + 1 >= days.count
    }
    
    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter.string(from: date)
    }
}
