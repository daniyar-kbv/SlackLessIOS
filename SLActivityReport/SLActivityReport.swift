//
//  SLActivityReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-21.
//

import DeviceActivity
import SwiftUI

//  Tech debt: refactor DI

@main
struct SLActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        SummaryScene(appSettingsRepository: makeRepositoryFactory().makeAppSettingsRepository())
        { .init(iTunesService: makeServiceFactory().makeITunesService(), days: $0) }
        ProgressScene(appSettingsRepository: makeRepositoryFactory().makeAppSettingsRepository()) { .init(weeks: $0) }
    }
    
    private func makeServiceFactory() -> ServiceFactory {
        ServiceFactoryImpl(apiFactory: makeAPIFactory(),
                           repositoryFactory: makeRepositoryFactory(),
                           helpersFactory: makeHelpersFactory())
    }
    
    private func makeAPIFactory() -> APIFactory {
        APIFactoryImpl()
    }
    
    private func makeRepositoryFactory() -> RepositoryFactory {
        RepositoryFactoryImpl(cacheStorage: BaseCacheStorage(), keyValueStorage: KeyValueStorageImpl(), secureStorage: SecureStorageImpl())
    }
    
    private func makeHelpersFactory() -> HelpersFactory {
        HelpersFactoryImpl(keyValueStorage: KeyValueStorageImpl())
    }
}
