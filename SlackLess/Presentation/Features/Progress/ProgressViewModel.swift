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
    func unlock()
    func finish()
}

protocol ProgressViewModelOutput {
    var date: BehaviorRelay<String?> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
    var showUnlockButton: BehaviorRelay<Bool> { get }
    var startUnlock: PublishRelay<Void> { get }
    var isFinished: PublishRelay<Void> { get }

    func getType() -> SLProgressType
    func getReportViewModel() -> SLReportViewModel
}

protocol ProgressViewModel: AnyObject {
    var input: ProgressViewModelInput { get }
    var output: ProgressViewModelOutput { get }
}

final class ProgressViewModelImpl: ProgressViewModel, ProgressViewModelInput, ProgressViewModelOutput {
    var input: ProgressViewModelInput { self }
    var output: ProgressViewModelOutput { self }

    private let type: SLProgressType
    private let appSettingsService: AppSettingsService

    private let disposeBag = DisposeBag()
    private lazy var currentDate = Date().getFirstDayOfWeek()
    private lazy var reportViewModel = SLReportViewModelImpl(type: type.reportType,
                                                             filter: type.reportType.getFilter())

    init(type: SLProgressType,
         appSettingsService: AppSettingsService)
    {
        self.type = type
        self.appSettingsService = appSettingsService

        configure()
        bindService()
        appSettingsService.input.checkData(forWeekOf: currentDate)
    }

    //    Output
    lazy var date: BehaviorRelay<String?> = .init(value: makeCurrentDateString())
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: isntFirstWeek())
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: isntLastWeek())
    lazy var showUnlockButton: BehaviorRelay<Bool> = .init(value: appSettingsService.output.getIsLocked())
    let startUnlock: PublishRelay<Void> = .init()
    lazy var isFinished: PublishRelay<Void> = .init()

    func getType() -> SLProgressType {
        type
    }
    
    func getReportViewModel() -> SLReportViewModel {
        reportViewModel
    }

    //    Input

    func changeDate(forward: Bool) {
        guard (forward && isntLastWeek()) || (!forward && isntFirstWeek()) else { return }
        currentDate = currentDate.add(.weekOfYear, value: forward ? 1 : -1)
        appSettingsService.input.set(progressDate: currentDate)
        appSettingsService.input.checkData(forWeekOf: currentDate)
        reload()
    }

    func unlock() {
        startUnlock.accept(())
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

    private func bindService() {
        appSettingsService.output.isLocked
            .bind(to: showUnlockButton)
            .disposed(by: disposeBag)
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
