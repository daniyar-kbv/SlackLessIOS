//
//  ActivityReportService.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import ManagedSettings

protocol ActivityReportService {
    func getTimeLimit() -> TimeInterval
    func getSelectedApplicationTokens() -> Set<ApplicationToken>?
}

final class ActivityReportServiceImpl: ActivityReportService {
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    func getTimeLimit() -> TimeInterval {
        keyValueStorage.timelimit
    }
    
    func getSelectedApplicationTokens() -> Set<ApplicationToken>? {
        keyValueStorage.selectedApps?.applicationTokens
    }
}
