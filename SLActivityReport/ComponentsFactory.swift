//
//  ComponentsFactory.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import Foundation

protocol ComponentsFactory {
    func makeRepositoryFactory() -> RepositoryFactory
}

final class ComponentsFactoryImpl: DependencyFactory, ComponentsFactory {
    func makeRepositoryFactory() -> RepositoryFactory {
        shared(RepositoryFactoryImpl())
    }
}
