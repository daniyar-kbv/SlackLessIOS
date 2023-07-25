//
//  AppCompoentsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol AppComponentsFactory: AnyObject {
    func makeDataComponenentsFactory() -> DataComponentsFactory
    func makeDomainComponentsFactory() -> DomainComponentsFactory
    func makePresentationComponentsFactory() -> PresentationComponentsFactory
    func makeHelpersFactory() -> HelpersFactory
}

final class AppComponentsFactoryImpl: DependencyFactory, AppComponentsFactory {
    
//    MARK: - Data Layer

    func makeDataComponenentsFactory() -> DataComponentsFactory {
        shared(DataComponenetsFactoryImpl())
    }
    
//    MARK: - Domain Layer
    
    func makeDomainComponentsFactory() -> DomainComponentsFactory {
        shared(DomainComponentsFactoryImpl(
            dataComponentsFactory: makeDataComponenentsFactory(),
            helpersFactory: makeHelpersFactory())
        )
    }
    
//    MARK: - Presentaion Layer
    
    func makePresentationComponentsFactory() -> PresentationComponentsFactory {
        weakShared(PresentationComponentsFactoryImpl(
            domainComponentsFactory: makeDomainComponentsFactory(),
            helpersFactory: makeHelpersFactory())
        )
    }

//    MARK: - Helpers

    public func makeHelpersFactory() -> HelpersFactory {
        return shared(HelpersFactoryImpl())
    }
}
