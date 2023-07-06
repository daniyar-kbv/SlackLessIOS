//
//  RepositoryComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol ServiceFactory: AnyObject {
    func makeScreenTimeService() -> ScreenTimeService
    func makeAppSettingsService() -> AppsSettingsService
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
    
    func makeScreenTimeService() -> ScreenTimeService {
        return weakShared(ScreenTimeServiceImpl(keyValueStorage: repositoryFactory.makeKeyValueStorage()))
    }
    
    func makeAppSettingsService() -> AppsSettingsService {
        return weakShared(AppsSettingsServiceImpl(keyValueStorage: repositoryFactory.makeKeyValueStorage()))
    }
}
