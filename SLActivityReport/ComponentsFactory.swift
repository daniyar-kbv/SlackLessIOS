//
//  ComponentsFactory.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import Foundation

protocol ComponentsFactory {
    func makeActivityReportService() -> ActivityReportService
    func makeControllersFactory() -> ControllersFactory
}

final class ComponentsFactoryImpl: DependencyFactory, ComponentsFactory {
    private func makeRepositoryFactory() -> RepositoryFactory {
        shared(RepositoryFactoryImpl())
    }
    
    func makeActivityReportService() -> ActivityReportService {
        shared(ActivityReportServiceImpl(keyValueStorage: makeRepositoryFactory().makeKeyValueStorage()))
    }
    
    func makeControllersFactory() -> ControllersFactory {
        shared(ControllersFactoryImpl())
    }
}
