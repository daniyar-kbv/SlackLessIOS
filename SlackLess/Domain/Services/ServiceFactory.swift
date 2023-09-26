//
//  ServiceFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol ServiceFactory: AnyObject {
    func makeAppSettingsService() -> AppSettingsService
    func mameAppLockingService() -> AppLockingService
}

final class ServiceFactoryImpl: DependencyFactory, ServiceFactory {
    private let apiFactory: APIFactory
    private let repositoryFactory: RepositoryFactory
    private let helpersFactory: HelpersFactory

    init(apiFactory: APIFactory,
         repositoryFactory: RepositoryFactory,
         helpersFactory: HelpersFactory)
    {
        self.apiFactory = apiFactory
        self.repositoryFactory = repositoryFactory
        self.helpersFactory = helpersFactory
    }

    func makeAppSettingsService() -> AppSettingsService {
        return shared(AppSettingsServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository(),
                                             eventManager: helpersFactory.makeEventManager()))
    }

    func mameAppLockingService() -> AppLockingService {
        return shared(AppLockingServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository(),
                                            eventManager: helpersFactory.makeEventManager()))
    }
}
