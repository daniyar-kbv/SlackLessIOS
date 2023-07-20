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
    func set(days: [ARDay])
    func changeDate(forward: Bool)
}

protocol SummaryReportViewModelOutput {
    var date: BehaviorRelay<String?> { get }
    var time: BehaviorRelay<ARTime?> { get }
    var selectedApps: BehaviorRelay<[ARApp]> { get }
    var otherApps: BehaviorRelay<[ARApp]> { get }
    var isFirstDate: BehaviorRelay<Bool?> { get }
    var isLastDate: BehaviorRelay<Bool?> { get }
    
    func getIcon(for appName: String, _ onCompletion: @escaping (URL) -> Void)
}

protocol SummaryReportViewModel: AnyObject {
    var input: SummaryReportViewModelInput { get }
    var output: SummaryReportViewModelOutput { get }
}

final class SummaryReportViewModelImpl: SummaryReportViewModel, SummaryReportViewModelInput, SummaryReportViewModelOutput {
    var input: SummaryReportViewModelInput { self }
    var output: SummaryReportViewModelOutput { self }
    
    private let iTunesService: ITunesService
    private var days: [ARDay] {
        didSet {
            currentIndex = days.count - 1
        }
    }
    private lazy var currentIndex = days.count - 1
    
    init(iTunesService: ITunesService,
         days: [ARDay]) {
        self.iTunesService = iTunesService
        self.days = days
    }
    
    //    Output
    lazy var date: BehaviorRelay<String?> = .init(value: format(date: Date()))
    lazy var time: BehaviorRelay<ARTime?> = .init(value: getCurrentDay()?.time)
    lazy var selectedApps: BehaviorRelay<[ARApp]> = .init(value: getCurrentDay()?.selectedApps ?? [])
    lazy var otherApps: BehaviorRelay<[ARApp]> = .init(value: getCurrentDay()?.otherApps ?? [])
    lazy var isFirstDate: BehaviorRelay<Bool?> = .init(value: false)
    lazy var isLastDate: BehaviorRelay<Bool?> = .init(value: true)
    
    func getIcon(for appName: String, _ onCompletion: @escaping (URL) -> Void) {
        iTunesService.output.getIconURL(for: appName, onCompletion)
    }
    
    //    Input
    
    func set(days: [ARDay]) {
        self.days = days
        reload()
    }
    
    func changeDate(forward: Bool) {
        guard (forward && !isLastDay()) || (!forward && !isFirstDay()) else { return }
        currentIndex = currentIndex + (forward ? 1 : -1)
        reload()
    }
}

extension SummaryReportViewModelImpl {
    private func reload() {
        date.accept(format(date: getCurrentDay()?.date))
        time.accept(getCurrentDay()?.time)
        selectedApps.accept(getCurrentDay()?.selectedApps ?? [])
        otherApps.accept(getCurrentDay()?.otherApps ?? [])
        isFirstDate.accept(isFirstDay())
        isLastDate.accept(isLastDay())
    }
    
    private func getCurrentDay() -> ARDay? {
        guard currentIndex >= 0 && currentIndex < days.count else { return nil }
        return days[currentIndex]
    }
    
    private func isFirstDay() -> Bool {
        currentIndex - 1 < 0
    }
    
    private func isLastDay() -> Bool {
        currentIndex + 1 >= days.count
    }
    
    private func format(date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter.string(from: date)
    }
}



