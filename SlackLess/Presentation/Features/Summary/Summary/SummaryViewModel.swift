//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol SummaryViewModelInput {
    func terminate()
    func changeDate(forward: Bool)
}

protocol SummaryViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
    var date: BehaviorRelay<String> { get }
    var isLastDate: BehaviorRelay<Bool> { get }
    
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }
    
    private var selectedDate = Date()

//    Output
    let didFinish: PublishRelay<Void> = .init()
    lazy var date: BehaviorRelay<String> = .init(value: format(date: Date()))
    lazy var isLastDate: BehaviorRelay<Bool> = .init(value: true)

//    Input
    func terminate() {
        didFinish.accept(())
    }
    
    func changeDate(forward: Bool) {
        let calendar = Calendar.current
        guard let modifiedDate = calendar.date(byAdding: .day, value: forward ? +1 : -1, to: selectedDate)
        else { return }
        selectedDate = modifiedDate
        date.accept(format(date: selectedDate))
        isLastDate.accept(calendar.compare(modifiedDate, to: Date(), toGranularity: .day) != .orderedAscending)
    }
}

extension SummaryViewModelImpl {
    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter.string(from: date)
    }
}
