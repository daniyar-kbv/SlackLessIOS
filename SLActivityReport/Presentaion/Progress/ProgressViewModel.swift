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
    func update(weeks: [ARWeek]?)
}

protocol ProgressViewModelOutput {
    var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> { get }
    var days: BehaviorRelay<[ARWeek.Day]> { get }
    var lastWeeks: BehaviorRelay<[ARWeek]> { get }
    var state: BehaviorRelay<ARViewState> { get }

    func getType() -> SLProgressType
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
    private let type: SLProgressType
    private var currentWeekIndex = 4
    
    private var weeks: [ARWeek]? {
        didSet {
            let setLoading = weeks?.isEmpty ?? true
            if setLoading && state.value != .loading {
                state.accept(.loading)
            } else if !setLoading && state.value != .loaded {
                state.accept(.loaded)
            }
        }
    }

    init(appSettingsService: AppSettingsService,
         type: SLProgressType,
         weeks: [ARWeek]?)
    {
        self.appSettingsService = appSettingsService
        self.type = type
        self.weeks = weeks

        bindService()
        configureDate()
    }

    //    Output
    lazy var time: BehaviorRelay<(currentWeekTime: ARTime?, previousWeekTime: ARTime?)> = .init(value: (currentWeekTime: getCurrentWeek()?.getTime(),
                                                                                                        previousWeekTime: getPreviousWeek()?.getTime()))
    lazy var days: BehaviorRelay<[ARWeek.Day]> = .init(value: getCurrentWeek()?.days ?? [])
    lazy var lastWeeks: BehaviorRelay<[ARWeek]> = .init(value: weeks ?? [])
    let state: BehaviorRelay<ARViewState> = .init(value: .loading)

    func getType() -> SLProgressType {
        type
    }

    //    Input
    func update(weeks: [ARWeek]?) {
        self.weeks = weeks
        reload()
    }
}

extension ProgressViewModelImpl {
    private func bindService() {
        switch type {
        case .normal:
            appSettingsService.output.progressDateObservable
                .subscribe(onNext: processProgressDate(_:))
                .disposed(by: disposeBag)
        case .weeklyReport:
            break
        }
    }

    private func configureDate() {
        switch type {
        case .normal:
            processProgressDate(appSettingsService.output.getProgressDate())
        case .weeklyReport:
            guard (weeks?.count ?? 0) > 1 else { return }
            currentWeekIndex = (weeks?.endIndex ?? 1) - 1
        }
    }

    private func processProgressDate(_ date: Date?) {
        guard let index = weeks?.firstIndex(where: { $0.startDate == date }) else { return }
        currentWeekIndex = index
        reload()
    }

    private func reload() {
        time.accept((currentWeekTime: getCurrentWeek()?.getTime(),
                     previousWeekTime: getPreviousWeek()?.getTime()))
        days.accept(getCurrentWeek()?.days ?? [])
        lastWeeks.accept(weeks ?? [])
    }

    private func getCurrentWeek() -> ARWeek? {
        guard !(weeks?.isEmpty ?? true) else { return nil }
        return weeks?[currentWeekIndex]
    }

    private func getPreviousWeek() -> ARWeek? {
        guard currentWeekIndex > 0, (weeks?.count ?? 0) > 1 else { return nil }
        return weeks?[currentWeekIndex - 1]
    }
}
