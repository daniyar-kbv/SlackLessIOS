//
//  AppComponentsFactory.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-23.
//

import Foundation

protocol AppComponentsFactory: AnyObject {
    func makeDataComponentsFactory() -> DataComponentsFactory
    func makeDomainComponentsFactory() -> DomainComponentsFactory
}

final class AppComponentsFactoryImpl: DependencyFactory, AppComponentsFactory {
    func makeDataComponentsFactory() -> DataComponentsFactory {
        shared(DataComponenetsFactoryImpl())
    }
    
    func makeDomainComponentsFactory() -> DomainComponentsFactory {
        shared(DomainComponentsFactoryImpl(dataComponentsFactory: makeDataComponentsFactory(),
                                    helpersFactory: makeHelpersFactory()))
    }
    
    private func makeHelpersFactory() -> HelpersFactoryImpl {
        shared(HelpersFactoryImpl())
    }
}
