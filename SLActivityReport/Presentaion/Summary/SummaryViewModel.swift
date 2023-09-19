//
//  SummaryViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol SummaryViewModelInput {
    func set(day: ARDay?)
}

protocol SummaryViewModelOutput {
    var time: BehaviorRelay<ARTime?> { get }
    var selectedApps: BehaviorRelay<[ARApp]> { get }
    var otherApps: BehaviorRelay<[ARApp]> { get }
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel,
    SummaryViewModelInput,
    SummaryViewModelOutput
{
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }

    private var day: ARDay?

    init(day: ARDay?) {
        self.day = day
    }

    //    Output
    lazy var time: BehaviorRelay<ARTime?> = .init(value: day?.time)
    lazy var selectedApps: BehaviorRelay<[ARApp]> = .init(value: day?.selectedApps ?? [])
    lazy var otherApps: BehaviorRelay<[ARApp]> = .init(value: day?.otherApps ?? [])

    //    Input

    func set(day: ARDay?) {
        self.day = day
        reload()
    }
}

extension SummaryViewModelImpl {
    private func reload() {
        time.accept(day?.time)
        selectedApps.accept(day?.selectedApps ?? [])
        otherApps.accept(day?.otherApps ?? [])
    }
}
