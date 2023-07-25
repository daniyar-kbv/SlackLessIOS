//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

protocol SummaryReportViewModelInput {
    func set(days: [ARDay])
    func changeDate(forward: Bool)
}

protocol SummaryReportViewModelOutput {
    var date: BehaviorRelay<String?> { get }
    var time: BehaviorRelay<ARTime?> { get }
    var selectedApps: BehaviorRelay<[ARApp]> { get }
    var otherApps: BehaviorRelay<[ARApp]> { get }
    var isntFirstDate: BehaviorRelay<Bool> { get }
    var isntLastDate: BehaviorRelay<Bool> { get }
    
    func getIcon(for appName: String, _ onCompletion: @escaping (UIImage) -> Void)
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
    
    private let appInfoService: AppInfoService
    private var days: [ARDay] {
        didSet {
            currentIndex = days.count - 1
        }
    }
    private lazy var currentIndex = days.count - 1
    
    init(appInfoService: AppInfoService,
         days: [ARDay]) {
        self.appInfoService = appInfoService
        self.days = days
    }
    
    //    Output
    lazy var date: BehaviorRelay<String?> = .init(value: Date().formatted(style: .long))
    lazy var time: BehaviorRelay<ARTime?> = .init(value: getCurrentDay()?.time)
    lazy var selectedApps: BehaviorRelay<[ARApp]> = .init(value: getCurrentDay()?.selectedApps ?? [])
    lazy var otherApps: BehaviorRelay<[ARApp]> = .init(value: getCurrentDay()?.otherApps ?? [])
    lazy var isntFirstDate: BehaviorRelay<Bool> = .init(value: true)
    lazy var isntLastDate: BehaviorRelay<Bool> = .init(value: false)
    
    func getIcon(for appName: String, _ onCompletion: @escaping (UIImage) -> Void) {
        let imageCache = ImageCache.default
        imageCache.retrieveImage(forKey: appName) { [weak self] in
            switch $0 {
            case let .success(result):
                guard let image = result.image else {
                    self?.fetchIcon(for: appName, onCompletion)
                    return
                }
                onCompletion(image)
            case .failure:
                self?.fetchIcon(for: appName, onCompletion)
            }
        }
    }
    
    //    Input
    
    func set(days: [ARDay]) {
        self.days = days
        reload()
    }
    
    func changeDate(forward: Bool) {
        guard (forward && isntLastDay()) || (!forward && isntFirstDay()) else { return }
        currentIndex = currentIndex + (forward ? 1 : -1)
        reload()
    }
}

extension SummaryReportViewModelImpl {
    private func fetchIcon(for appName: String, _ onCompletion: @escaping (UIImage) -> Void) {
        appInfoService.output.getIconURL(for: appName) {
            KingfisherManager.shared.retrieveImage(with: ImageResource(downloadURL: $0, cacheKey: appName)) {
                switch $0 {
                case let .success(imageResult):
                    onCompletion(imageResult.image)
                case .failure: break
                }
            }
        }
    }
    
    private func reload() {
        date.accept(getCurrentDay()?.date.formatted(style: .long))
        time.accept(getCurrentDay()?.time)
        selectedApps.accept(getCurrentDay()?.selectedApps ?? [])
        otherApps.accept(getCurrentDay()?.otherApps ?? [])
        isntFirstDate.accept(isntFirstDay())
        isntLastDate.accept(isntLastDay())
    }
    
    private func getCurrentDay() -> ARDay? {
        guard days.count > 0 else { return nil }
        return days[currentIndex]
    }
    
    private func isntFirstDay() -> Bool {
        currentIndex - 1 >= 0
    }
    
    private func isntLastDay() -> Bool {
        currentIndex + 1 < days.count
    }
}
