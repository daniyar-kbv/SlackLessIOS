//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol SummaryPageViewModelInput {
    
}

protocol SummaryPageViewModelOutput {
    func getTime() -> ActivityReportTime
    func getSelectedApps() -> [ActivityReportApp]
    func getOtherApps() -> [ActivityReportApp]
}

protocol SummaryPageViewModel: AnyObject {
    var input: SummaryPageViewModelInput { get }
    var output: SummaryPageViewModelOutput { get }
}

final class SummaryPageViewModelImpl: SummaryPageViewModel, SummaryPageViewModelInput, SummaryPageViewModelOutput {
    var input: SummaryPageViewModelInput { self }
    var output: SummaryPageViewModelOutput { self }
    
    private let day: ActivityReportDay
    private var selectedDate = Date()
    
    init(day: ActivityReportDay) {
        self.day = day
    }
    
    //    Output
    
    func getTime() -> ActivityReportTime {
        day.time
    }
    
    func getSelectedApps() -> [ActivityReportApp] {
        day.selectedApps
    }
    
    func getOtherApps() -> [ActivityReportApp] {
        day.otherApps
    }
    
    //    Input
}


