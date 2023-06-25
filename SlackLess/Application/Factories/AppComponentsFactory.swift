//
//  AppCompoentsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol AppComponentsFactory: AnyObject {
    func makeRepositoryFactory() -> RepositoryFactory
    func makeServiceFactory() -> ServiceFactory
    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory
    func makeApplicationModulesFactory() -> ApplicationModulesFactory
    func makeHelpersFactory() -> HelpersFactory

    func makeKeyValueStorage() -> KeyValueStorage
}

final class AppComponentsFactoryImpl: DependencyFactory, AppComponentsFactory {
//    MARK: - ApplicationCoordinators

    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory {
        return shared(ApplicationCoordinatorFactoryImpl(routersFactory: makeRoutersFactory(),
                                                        serviceFactory: makeServiceFactory()))
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

//    MARK: - Network

    func makeAPIFactory() -> APIFactory {
        return shared(APIFactoryImpl())
    }

//    MARK: - Storage

    func makeRepositoryFactory() -> RepositoryFactory {
        return shared(RepositoryFactoryImpl())
    }

    private func makeSecureStorage() -> SecureStorage {
        return shared(SecureStorageImpl())
    }

    public func makeKeyValueStorage() -> KeyValueStorage {
        return shared(KeyValueStorageImpl())
    }

    private func makeCacheStorage() -> BaseCacheStorage {
        return shared(BaseCacheStorage())
    }

//    MARK: - Reachability

    public func makeHelpersFactory() -> HelpersFactory {
        return shared(HelpersFactoryImpl(keyValueStorage: makeKeyValueStorage()))
    }
}
