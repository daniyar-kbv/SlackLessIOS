//
//  SLDeviceActivityReportFilter.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI
import DeviceActivity

class SLDeviceActivityReportFilter {
    internal let reportType: SLDeviceActivityReportType
    internal let filter: DeviceActivityFilter
    internal let relay: BehaviorRelay<(SLDeviceActivityReportType, DeviceActivityFilter)>
    
    init(reportType: SLDeviceActivityReportType, filter: DeviceActivityFilter) {
        self.reportType = reportType
        self.filter = filter
        self.relay = .init(value: (reportType, filter))
    }
}

extension Array where Element: SLDeviceActivityReportFilter {
    func accept(filter: DeviceActivityFilter, for reportType: SLDeviceActivityReportType) {
        first(where: { $0.reportType == reportType })?.relay.accept((reportType, filter))
    }
    
    func subscribe(disposeBag: DisposeBag, onNext: @escaping (SLDeviceActivityReportType, DeviceActivityFilter) -> Void) {
        forEach({
            $0.relay.subscribe(onNext: {
                onNext($0, $1)
            })
            .disposed(by: disposeBag)
        })
    }
}
