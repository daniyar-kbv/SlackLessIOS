//
//  ProgressPastWeeksViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProgressPastWeeksViewModelInput {
    func set(weeks: [ARWeek])
}

protocol ProgressPastWeeksViewModelOutput {
    var weeks: BehaviorRelay<[ARWeek]> { get }
}

protocol ProgressPastWeeksViewModel: AnyObject {
    var input: ProgressPastWeeksViewModelInput { get }
    var output: ProgressPastWeeksViewModelOutput { get }
}

final class ProgressPastWeeksViewModelImpl: ProgressPastWeeksViewModel,
                                         ProgressPastWeeksViewModelInput,
                                         ProgressPastWeeksViewModelOutput {
    var input: ProgressPastWeeksViewModelInput { self }
    var output: ProgressPastWeeksViewModelOutput { self }
    
    private var allWeeks: [ARWeek]
    
    init(weeks: [ARWeek]) {
        self.allWeeks = weeks
    }
    
    //    Output
    lazy var weeks: BehaviorRelay<[ARWeek]> = .init(value: getFiveWeeks())
    
    //    Input
    func set(weeks: [ARWeek]) {
        self.allWeeks = weeks
        reload()
    }
}

extension ProgressPastWeeksViewModelImpl {
    private func reload() {
        weeks.accept(getFiveWeeks())
    }
    
    private func getFiveWeeks() -> [ARWeek] {
        return allWeeks.suffix(5)
    }
}


