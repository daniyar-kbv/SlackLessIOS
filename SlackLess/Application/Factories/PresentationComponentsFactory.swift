//
//  PresentationComponentsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-23.
//

import Foundation

protocol PresentationComponentsFactory: AnyObject {
    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory
    func makeApplicationModulesFactory() -> ApplicationModulesFactory
}

final class PresentationComponentsFactoryImpl: DependencyFactory, PresentationComponentsFactory {
    private let domainComponentsFactory: DomainComponentsFactory
    private let helpersFactory: HelpersFactory
    
    init(domainComponentsFactory: DomainComponentsFactory,
         helpersFactory: HelpersFactory) {
        self.domainComponentsFactory = domainComponentsFactory
        self.helpersFactory = helpersFactory
    }
    
//    MARK: - ApplicationCoordinators

    func makeApplicationCoordinatorFactory() -> ApplicationCoordinatorFactory {
        return shared(ApplicationCoordinatorFactoryImpl(
            routersFactory: makeRoutersFactory(),
            serviceFactory: domainComponentsFactory.makeServiceFactory(),
            helpersFactory: helpersFactory)
        )
    }

    func makeRoutersFactory() -> RoutersFactory {
        return shared(RoutersFactoryImpl())
    }

//    MARK: - ApplicationModules

    func makeApplicationModulesFactory() -> ApplicationModulesFactory {
        return shared(ApplicationModulesFactoryImpl(serviceFactory: domainComponentsFactory.makeServiceFactory()))
    }
}
