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
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
}

protocol ProgressViewModel: SLReportsViewModel {
    var input: ProgressViewModelInput { get }
    var output: ProgressViewModelOutput { get }
}

final class ProgressViewModelImpl: ProgressViewModel, ProgressViewModelInput, ProgressViewModelOutput {
    var input: ProgressViewModelInput { self }
    var output: ProgressViewModelOutput { self }
    
    private lazy var currentDate = Date().getFirstDayOfWeek()
    private let appSettingsService: AppSettingsService
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
        
        appSettingsService.input.set(progressDate: currentDate)
    }
    
    //    Output
    lazy var filters: [SLDeviceActivityReportFilter] = [
        .init(reportType: .progress, filter: SLDeviceActivityReportType.progress.getFilter()),
    ]
    lazy var date: BehaviorRelay<String?> = .init(value: makeCurrentDateString())
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstWeek())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastWeek())
    
    //    Input
    
    func changeDate(forward: Bool) {
        guard (forward && isntLastWeek()) || (!forward && isntFirstWeek()) else { return }
        currentDate = currentDate.add(.weekOfYear, value: forward ? 1 : -1)
        appSettingsService.input.set(progressDate: currentDate)
        reload()
    }
}

extension ProgressViewModelImpl {
    private func reload() {
        date.accept(makeCurrentDateString())
        isntFirstDate.accept(isntFirstWeek())
        isntLastDate.accept(isntLastWeek())
    }
    
    private func isntFirstWeek() -> Bool {
        !appSettingsService.output.getIsLastWeek(currentDate)
    }
    
    private func isntLastWeek() -> Bool {
        currentDate != Date().getFirstDayOfWeek()
    }
    
    private func makeCurrentDateString() -> String {
        "\(currentDate.formatted(style: .short)) - \(currentDate.getLastDayOfWeek().formatted(style: .short))"
    }
}

