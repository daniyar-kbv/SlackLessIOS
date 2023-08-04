//
//  ProgressViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import RxSwift
import RxCocoa
import DeviceActivity

protocol ProgressViewModelInput {
    func changeDate(forward: Bool)
}

protocol ProgressViewModelOutput {
    var weekFilter: BehaviorRelay<DeviceActivityFilter> { get }
    var pastWeeksFilter: BehaviorRelay<DeviceActivityFilter> { get }
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
}

protocol ProgressViewModel: AnyObject {
    var input: ProgressViewModelInput { get }
    var output: ProgressViewModelOutput { get }
}

final class ProgressViewModelImpl: ProgressViewModel, ProgressViewModelInput, ProgressViewModelOutput {
    var input: ProgressViewModelInput { self }
    var output: ProgressViewModelOutput { self }
    
    private var currentDate = Date()
    private let appSettingsService: AppSettingsService
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }
    
    //    Output
    lazy var weekFilter: BehaviorRelay<DeviceActivityFilter> = .init(value: makeWeekFilter())
    lazy var pastWeeksFilter: BehaviorRelay<DeviceActivityFilter> = .init(value: makePastWeeksFilter())
    lazy var date: BehaviorRelay<String?> = .init(value: makeCurrentDateString())
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstWeek())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastWeek())
    
    //    Input
    
    func changeDate(forward: Bool) {
        guard (forward && isntLastWeek()) || (!forward && isntFirstWeek()) else { return }
        currentDate = Calendar.current.date(byAdding: .weekOfYear,
                                            value: forward ? 1 : -1,
                                            to: currentDate)!
        reload()
    }
}

extension ProgressViewModelImpl {
    private func reload() {
        weekFilter.accept(makeWeekFilter())
        date.accept(makeCurrentDateString())
        isntFirstDate.accept(isntFirstWeek())
        isntLastDate.accept(isntLastWeek())
    }
    
    private func isntFirstWeek() -> Bool {
        !appSettingsService.output.getIsLastWeek(currentDate)
    }
    
    private func isntLastWeek() -> Bool {
        currentDate.compareByDate(to: Date()) == .orderedAscending
    }
    
    private func makeWeekFilter() -> DeviceActivityFilter {
        let calendar = Calendar.current
        let minusWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let startDate = calendar.dateInterval(of: .weekOfYear, for: minusWeekDate)!.start
        let endDate = calendar.dateInterval(of: .weekOfYear, for: Date())!.end
        return DeviceActivityFilter(
            segment: .daily(
                during: .init(start: startDate,
                              end: endDate)
            ),
            users: .all,
            devices: .init([.iPhone])
        )
    }
    
    private func makePastWeeksFilter() -> DeviceActivityFilter {
        let calendar = Calendar.current
        let minusFiveWeeksDate = calendar.date(byAdding: .weekOfYear, value: -4, to: Date())!
        let startDate = calendar.dateInterval(of: .weekOfYear, for: minusFiveWeeksDate)!.start
        let endDate = calendar.dateInterval(of: .weekOfYear, for: Date())!.end
        return DeviceActivityFilter(
            segment: .weekly(
                during: .init(start: startDate,
                              end: endDate)
            ),
            users: .all,
            devices: .init([.iPhone])
        )
    }
    
    private func makeCurrentDateString() -> String {
        "\(currentDate.getFirstDayOfWeek().formatted(style: .short)) - \(currentDate.getLastDayOfWeek().formatted(style: .short))"
    }
}

