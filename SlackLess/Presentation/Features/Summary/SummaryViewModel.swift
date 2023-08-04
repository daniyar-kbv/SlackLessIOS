//
//  SummaryViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import Foundation
import RxSwift
import RxCocoa
import DeviceActivity

protocol SummaryViewModelInput {
    func changeDate(forward: Bool)
}

protocol SummaryViewModelOutput {
    var filter: BehaviorRelay<DeviceActivityFilter> { get }
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }
    
    private var currentDate = Date()
    private let appSettingsService: AppSettingsService
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }
    
    //    Output
    lazy var filter: BehaviorRelay<DeviceActivityFilter> = .init(value: makeFilter())
    lazy var date: BehaviorRelay<String?> = .init(value: Date().formatted(style: .long))
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstDay())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastDay())
    
    //    Input
    
    func changeDate(forward: Bool) {
        guard (forward && isntLastDay()) || (!forward && isntFirstDay()) else { return }
        currentDate = Calendar.current.date(byAdding: .day,
                                            value: forward ? 1 : -1,
                                            to: currentDate)!
        reload()
    }
}

extension SummaryViewModelImpl {
    private func reload() {
        filter.accept(makeFilter())
        date.accept(currentDate.formatted(style: .long))
        isntFirstDate.accept(isntFirstDay())
        isntLastDate.accept(isntLastDay())
    }
    
    private func isntFirstDay() -> Bool {
        !appSettingsService.output.getIsLastDate(currentDate)
    }
    
    private func isntLastDay() -> Bool {
        currentDate.compareByDate(to: Date()) == .orderedAscending
    }
    
    private func makeFilter() -> DeviceActivityFilter {
        DeviceActivityFilter(
            segment: .daily(
                during: Calendar.current.dateInterval(
                    of: .day, for: currentDate
                 )!
            ),
            users: .all,
            devices: .init([.iPhone])
        )
    }
}
