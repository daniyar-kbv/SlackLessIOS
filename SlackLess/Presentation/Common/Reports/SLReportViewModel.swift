//
//  SLReportViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-12.
//

import Foundation
import RxSwift
import RxCocoa
import DeviceActivity

protocol SLReportViewModelInput: AnyObject {
    func update(filter: DeviceActivityFilter)
}

protocol SLReportViewModelOutput: AnyObject {
    var reload: PublishRelay<Void> { get }
    
    func getType() -> SLReportType
    func getFilter() -> DeviceActivityFilter
}

protocol SLReportViewModel: AnyObject {
    var input: SLReportViewModelInput { get }
    var output: SLReportViewModelOutput { get }
}

final class SLReportViewModelImpl: SLReportViewModel, SLReportViewModelInput, SLReportViewModelOutput {
    var input: SLReportViewModelInput { self }
    var output: SLReportViewModelOutput { self }
    
    private let type: SLReportType
    private var filter: DeviceActivityFilter
    
    init(type: SLReportType, filter: DeviceActivityFilter) {
        self.type = type
        self.filter = filter
    }
    
    //    Output
    let reload: PublishRelay<Void> = .init()
    
    func getType() -> SLReportType {
        type
    }
    
    func getFilter() -> DeviceActivityFilter {
        filter
    }
    
    //    Input
    func update(filter: DeviceActivityFilter) {
        self.filter = filter
        reload.accept(())
    }
}
