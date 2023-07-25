//
//  DomainComponentsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-23.
//

import Foundation

protocol DomainComponentsFactory: AnyObject {
    func makeServiceFactory() -> ServiceFactory
}

final class DomainComponentsFactoryImpl: DependencyFactory, DomainComponentsFactory {
    private let dataComponentsFactory: DataComponentsFactory
    private let helpersFactory: HelpersFactory
    
    init(dataComponentsFactory: DataComponentsFactory,
         helpersFactory: HelpersFactory) {
        self.helpersFactory = helpersFactory
        self.dataComponentsFactory = dataComponentsFactory
    }

    func makeServiceFactory() -> ServiceFactory {
        return shared(ServiceFactoryImpl(
            apiFactory: dataComponentsFactory.makeAPIFactory(),
            repositoryFactory: dataComponentsFactory.makeRepositoryFactory(),
            helpersFactory: helpersFactory)
        )
    }
}
