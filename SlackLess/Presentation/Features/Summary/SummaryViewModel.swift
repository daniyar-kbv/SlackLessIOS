//
//  SummaryViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift

protocol SummaryViewModelInput: AnyObject {
    func changeDate(forward: Bool)
}

protocol SummaryViewModelOutput: AnyObject {
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
    
    func getReportViewModel() -> SLReportViewModel
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }

    private let appSettingsService: AppSettingsService

    private let disposeBag = DisposeBag()
    private var currentDate = Date().getDate()
    private let reportType: SLReportType = .summary
    private lazy var reportViewModel = SLReportViewModelImpl(type: reportType, filter: makeFilter())

    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }

    //    Output
    
    lazy var date: BehaviorRelay<String?> = .init(value: Date().formatted(style: .long))
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstDay())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastDay())
    
    func getReportViewModel() -> SLReportViewModel {
        reportViewModel
    }

    //    Input

    func changeDate(forward: Bool) {
        guard (forward && isntLastDay()) || (!forward && isntFirstDay()) else { return }
        currentDate = currentDate.add(.day, value: forward ? 1 : -1)
        reload()
    }
}

extension SummaryViewModelImpl {
    private func reload() {
        reportViewModel.update(filter: makeFilter())
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
        SLReportType.summary.getFilter(for: currentDate)
    }
}
