//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol SummaryReportViewModelInput {
    func set(day: ARDay?)
}

protocol SummaryReportViewModelOutput {
    var time: BehaviorRelay<ARTime?> { get }
    var selectedApps: BehaviorRelay<[ARApp]> { get }
    var otherApps: BehaviorRelay<[ARApp]> { get }
}

protocol SummaryReportViewModel: AnyObject {
    var input: SummaryReportViewModelInput { get }
    var output: SummaryReportViewModelOutput { get }
}

final class SummaryReportViewModelImpl: SummaryReportViewModel,
                                        SummaryReportViewModelInput,
                                        SummaryReportViewModelOutput {
    var input: SummaryReportViewModelInput { self }
    var output: SummaryReportViewModelOutput { self }
    
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

extension SummaryReportViewModelImpl {
    private func reload() {
        time.accept(day?.time)
        selectedApps.accept(day?.selectedApps ?? [])
        otherApps.accept(day?.otherApps ?? [])
    }
}
