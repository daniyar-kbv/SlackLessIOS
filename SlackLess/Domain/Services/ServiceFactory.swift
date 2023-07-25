//
//  RepositoryComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol ServiceFactory: AnyObject {
    func makeAppSettingsService() -> AppSettingsService
    func makeAppInfoService() -> AppInfoService
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
        return weakShared(AppSettingsServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository()))
    }
    
    func makeAppInfoService() -> AppInfoService {
        return weakShared(AppInfoServiceImpl(iTunesAPI: apiFactory.makeITunesAPI()))
    }
}
