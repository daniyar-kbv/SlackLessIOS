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
    let keyValyeStorage: KeyValueStorage
    let repositoryFactory: RepositoryFactory
    let apiFactory: APIFactory
    let helpersFactory: HelpersFactory
    let serviceFacroty: ServiceFactory
    
    init() {
        self.keyValyeStorage = KeyValueStorageImpl()
        self.repositoryFactory = RepositoryFactoryImpl(cacheStorage: BaseCacheStorage(),
                                                       keyValueStorage: keyValyeStorage,
                                                       secureStorage: SecureStorageImpl())
        self.apiFactory = APIFactoryImpl()
        self.helpersFactory = HelpersFactoryImpl(keyValueStorage: keyValyeStorage)
        self.serviceFacroty = ServiceFactoryImpl(apiFactory: apiFactory,
                                                 repositoryFactory: repositoryFactory,
                                                 helpersFactory: helpersFactory)
    }
    
    var body: some DeviceActivityReportScene {
        SummaryScene(appSettingsRepository: repositoryFactory.makeAppSettingsRepository())
        { .init(iTunesService: serviceFacroty.makeITunesService(), days: $0) }
        ProgressScene(appSettingsRepository: repositoryFactory.makeAppSettingsRepository()) { .init(weeks: $0) }
    }
}
