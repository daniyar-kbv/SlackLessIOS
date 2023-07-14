//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol ActivityReportSummaryViewModelInput {
    func terminate()
    func changeDate(forward: Bool)
}

protocol ActivityReportSummaryViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
    var date: BehaviorRelay<String> { get }
    var isLastDate: BehaviorRelay<Bool> { get }
    
    func getTime() -> ActivityReportTime
    func getSelectedApps() -> [ActivityReportApp]
}

protocol ActivityReportSummaryViewModel: AnyObject {
    var input: ActivityReportSummaryViewModelInput { get }
    var output: ActivityReportSummaryViewModelOutput { get }
}

final class ActivityReportSummaryViewModelImpl: ActivityReportSummaryViewModel, ActivityReportSummaryViewModelInput, ActivityReportSummaryViewModelOutput {
    var input: ActivityReportSummaryViewModelInput { self }
    var output: ActivityReportSummaryViewModelOutput { self }
    
    private let time: ActivityReportTime
    private var selectedDate = Date()
    
    init(time: ActivityReportTime) {
        self.time = time
    }

//    Output
    let didFinish: PublishRelay<Void> = .init()
    lazy var date: BehaviorRelay<String> = .init(value: format(date: Date()))
    lazy var isLastDate: BehaviorRelay<Bool> = .init(value: true)
    
    func getTime() -> ActivityReportTime {
        .init(slacked: 4800, total: 19500, limit: 10800)
    }

    func getSelectedApps() -> [ActivityReportApp] {
        let minTime = 60.0
        let maxTime = 6000.0
        let num = 20
        return (0..<num)
            .map({
                let time = minTime+((maxTime-minTime)/Double(num)*Double($0))
                return .init(name: "App \($0)",
                             icon: nil,
                             time: time,
                             ratio: (time-minTime)/(maxTime-minTime))
            })
            .reversed()
    }
    
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

extension ActivityReportSummaryViewModelImpl {
    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter.string(from: date)
    }
}
