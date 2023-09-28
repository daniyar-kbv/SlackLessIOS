//
//  ProgressViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift

protocol ProgressViewModelInput {
    func changeDate(forward: Bool)
    func finish()
}

protocol ProgressViewModelOutput {
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
    var isFinished: PublishRelay<Void> { get }

    func getType() -> SLProgressType
}

protocol ProgressViewModel: SLReportsViewModel {
    var input: ProgressViewModelInput { get }
    var output: ProgressViewModelOutput { get }
}

final class ProgressViewModelImpl: ProgressViewModel, ProgressViewModelInput, ProgressViewModelOutput {
    var input: ProgressViewModelInput { self }
    var output: ProgressViewModelOutput { self }

    private let type: SLProgressType
    private let appSettingsService: AppSettingsService
    private lazy var currentDate = Date().getFirstDayOfWeek()

    init(type: SLProgressType,
         appSettingsService: AppSettingsService)
    {
        self.type = type
        self.appSettingsService = appSettingsService

        configure()
    }

    //    Output
    lazy var filters: [SLDeviceActivityReportFilter] = [
        .init(reportType: type.reportType, filter: type.reportType.getFilter()),
    ]
    lazy var date: BehaviorRelay<String?> = .init(value: makeCurrentDateString())
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstWeek())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastWeek())
    lazy var isFinished: PublishRelay<Void> = .init()

    func getType() -> SLProgressType {
        type
    }

    //    Input

    func changeDate(forward: Bool) {
        guard (forward && isntLastWeek()) || (!forward && isntFirstWeek()) else { return }
        currentDate = currentDate.add(.weekOfYear, value: forward ? 1 : -1)
        appSettingsService.input.set(progressDate: currentDate)
        reload()
    }

    func finish() {
        isFinished.accept(())
    }
}

extension ProgressViewModelImpl {
    private func configure() {
        switch type {
        case .normal:
            appSettingsService.input.set(progressDate: currentDate)
        case .weeklyReport:
            changeDate(forward: false)
        }
    }

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
