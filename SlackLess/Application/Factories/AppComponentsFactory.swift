//
//  AppCompoentsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol AppComponentsFactory: AnyObject {
    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory
    func makeApplicationModulesFactory() -> ApplicationModulesFactory
    func makeServiceFactory() -> ServiceFactory
    func makeHelpersFactory() -> HelpersFactory
    func makeAPIFactory() -> APIFactory
    func makeRepositoryFactory() -> RepositoryFactory
    func makeSecureStorage() -> SecureStorage
    func makeKeyValueStorage() -> KeyValueStorage
    func makeCacheStorage() -> BaseCacheStorage
}

final class AppComponentsFactoryImpl: DependencyFactory, AppComponentsFactory {
//    MARK: - ApplicationCoordinators

    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory {
        return shared(ApplicationCoordinatorFactoryImpl(routersFactory: makeRoutersFactory(),
                                                        serviceFactory: makeServiceFactory(),
                                                        helpersFactory: makeHelpersFactory()))
    }

    func makeRoutersFactory() -> RoutersFactory {
        return shared(RoutersFactoryImpl())
    }

//    MARK: - ApplicationModules

    func makeApplicationModulesFactory() -> ApplicationModulesFactory {
        return shared(ApplicationModulesFactoryImpl(serviceFactory: makeServiceFactory()))
    }

//    MARK: - Services

    func makeServiceFactory() -> ServiceFactory {
        return shared(ServiceFactoryImpl(apiFactory: makeAPIFactory(),
                                         repositoryFactory: makeRepositoryFactory(),
                                         helpersFactory: makeHelpersFactory()))
    }
    
//    MARK: - Reachability

    public func makeHelpersFactory() -> HelpersFactory {
        return shared(HelpersFactoryImpl(keyValueStorage: makeKeyValueStorage()))
    }

//    MARK: - Network

    func makeAPIFactory() -> APIFactory {
        return shared(APIFactoryImpl())
    }

//    MARK: - Storage

    func makeRepositoryFactory() -> RepositoryFactory {
        return shared(RepositoryFactoryImpl(cacheStorage: makeCacheStorage(),
                                            keyValueStorage: makeKeyValueStorage(),
                                            secureStorage: makeSecureStorage()))
    }

    func makeSecureStorage() -> SecureStorage {
        return shared(SecureStorageImpl())
    }

    func makeKeyValueStorage() -> KeyValueStorage {
        return shared(KeyValueStorageImpl())
    }

    func makeCacheStorage() -> BaseCacheStorage {
        return shared(BaseCacheStorage())
    }
}
