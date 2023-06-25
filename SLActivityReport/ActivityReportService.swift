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
    private let repositiryFactory: RepositoryFactory
    
    init(repositiryFactory: RepositoryFactory) {
        self.repositiryFactory = repositiryFactory
    }
    
    func getTimeLimit() -> TimeInterval {
        let storage = repositiryFactory.makeKeyValueStorage()
        return storage.timelimit
    }
    
    func getSelectedApplicationTokens() -> Set<ApplicationToken>? {
        let storage = repositiryFactory.makeKeyValueStorage()
        return storage.selectedApps?.applicationTokens
    }
}
