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

protocol SummaryViewModelInput: AnyObject {
    func changeDate(forward: Bool)
}

protocol SummaryViewModelOutput: AnyObject {
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
}

protocol SummaryViewModel: SLReportsViewModel {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SLReportsViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }
    
    private var currentDate = Date().getDate()
    private let appSettingsService: AppSettingsService
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }
    
    //    Output
    lazy var filters: [SLDeviceActivityReportFilter] = [.init(reportType: .summary, filter: makeFilter())]
    lazy var date: BehaviorRelay<String?> = .init(value: Date().formatted(style: .long))
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstDay())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastDay())
    
    //    Input
    
    func changeDate(forward: Bool) {
        guard (forward && isntLastDay()) || (!forward && isntFirstDay()) else { return }
        currentDate = currentDate.add(.day, value: forward ? 1 : -1)
        reload()
    }
}

extension SummaryViewModelImpl {
    private func reload() {
        filters.accept(filter: makeFilter(), for: .summary)
        date.accept(currentDate.formatted(style: .long))
        isntFirstDate.accept(isntFirstDay())
        isntLastDate.accept(isntLastDay())
    }
    
    private func isntFirstDay() -> Bool {
        !appSettingsService.output.getIsLastDate(currentDate)
    }
    
    private func isntLastDay() -> Bool {
        return currentDate != Date().getDate()
    }
    
    private func makeFilter() -> DeviceActivityFilter {
        SLDeviceActivityReportType.summary.getFilter(for: currentDate)
    }
}
