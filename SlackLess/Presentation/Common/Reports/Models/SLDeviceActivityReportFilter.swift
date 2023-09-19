//
//  SLDeviceActivityReportFilter.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SwiftUI

class SLDeviceActivityReportFilter {
    let reportType: SLDeviceActivityReportType
    let filter: DeviceActivityFilter
    let relay: BehaviorRelay<(SLDeviceActivityReportType, DeviceActivityFilter)>

    init(reportType: SLDeviceActivityReportType, filter: DeviceActivityFilter) {
        self.reportType = reportType
        self.filter = filter
        relay = .init(value: (reportType, filter))
    }
}

extension Array where Element: SLDeviceActivityReportFilter {
    func accept(filter: DeviceActivityFilter, for reportType: SLDeviceActivityReportType) {
        first(where: { $0.reportType == reportType })?.relay.accept((reportType, filter))
    }

    func subscribe(disposeBag: DisposeBag, onNext: @escaping (SLDeviceActivityReportType, DeviceActivityFilter) -> Void) {
        forEach {
            $0.relay.subscribe(onNext: {
                onNext($0, $1)
            })
            .disposed(by: disposeBag)
        }
    }
}
