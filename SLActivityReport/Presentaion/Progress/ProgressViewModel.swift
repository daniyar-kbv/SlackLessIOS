//
//  ProgressViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProgressViewModelInput {
    func update(weeks: [ARWeek])
}

protocol ProgressViewModelOutput {
    var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> { get }
    var days: BehaviorRelay<[ARWeek.Day]> { get }
    var lastWeeks: BehaviorRelay<[ARWeek]> { get }
}

protocol ProgressViewModel: AnyObject {
    var input: ProgressViewModelInput { get }
    var output: ProgressViewModelOutput { get }
}

final class ProgressViewModelImpl: ProgressViewModel,
    ProgressViewModelInput,
    ProgressViewModelOutput
{
    var input: ProgressViewModelInput { self }
    var output: ProgressViewModelOutput { self }

    private let disposeBag = DisposeBag()
    private let appSettingsService: AppSettingsService
    private var weeks: [ARWeek]
    private var currentWeekIndex = 4

    init(appSettingsService: AppSettingsService,
         weeks: [ARWeek])
    {
        self.appSettingsService = appSettingsService
        self.weeks = weeks

        bindService()
        processProgressDate(appSettingsService.output.getProgressDate())
    }

    //    Output
    lazy var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> = .init(value: (currentWeekTime: getCurrentWeek()?.getTime(),
                                                                                                        previousWeekTime: getPreviousWeek()?.getTime()))
    lazy var days: BehaviorRelay<[ARWeek.Day]> = .init(value: getCurrentWeek()?.days ?? [])
    lazy var lastWeeks: BehaviorRelay<[ARWeek]> = .init(value: weeks)

    //    Input
    func update(weeks: [ARWeek]) {
        self.weeks = weeks
        reload()
    }
}

extension ProgressViewModelImpl {
    private func bindService() {
        appSettingsService.output.progressDateObservable
            .subscribe(onNext: processProgressDate(_:))
            .disposed(by: disposeBag)
    }

    private func processProgressDate(_ date: Date?) {
        guard let index = weeks.firstIndex(where: { $0.startDate == date }) else { return }
        currentWeekIndex = index
        reload()
    }

    private func reload() {
        time.accept((currentWeekTime: getCurrentWeek()?.getTime(),
                     previousWeekTime: getPreviousWeek()?.getTime()))
        days.accept(getCurrentWeek()?.days ?? [])
        lastWeeks.accept(weeks)
    }

    private func getCurrentWeek() -> ARWeek? {
        guard !weeks.isEmpty else { return nil }
        return weeks[currentWeekIndex]
    }

    private func getPreviousWeek() -> ARWeek? {
        guard currentWeekIndex > 0, weeks.count > 1 else { return nil }
        return weeks[currentWeekIndex - 1]
    }
}
