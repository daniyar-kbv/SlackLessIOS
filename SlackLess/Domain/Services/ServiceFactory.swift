//
//  ServiceFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol ServiceFactory: AnyObject {
    func makeAppSettingsService() -> AppSettingsService
    func makeLockService() -> LockService
    func makePushNotificationsService() -> PushNotificationsService
    func makeFeedbackService() -> FeedbackService
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
        shared(AppSettingsServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository(),
                                      eventManager: helpersFactory.makeEventManager()))
    }

    func makeLockService() -> LockService {
        shared(LockServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository(),
                               eventManager: helpersFactory.makeEventManager()))
    }
    
    func makePushNotificationsService() -> PushNotificationsService {
        shared(PushNotificationsServiceImpl(appSettingsRepository: repositoryFactory.makeAppSettingsRepository()))
    }
    
    func makeFeedbackService() -> FeedbackService {
        shared(FeedbackServiceImpl(feedbackAPI: apiFactory.makeFeedbackAPI()))
    }
}
