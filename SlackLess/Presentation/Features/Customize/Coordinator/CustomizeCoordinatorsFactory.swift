//
//  CustomizeCoordinatorsFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-12-04.
//

import Foundation

protocol CustomizeCoordinatorsFactory: AnyObject {
    func makeWeeklyReportCoordinator() -> WeeklyReportCoordinator
}

final class CustomizeCoordinatorsFactoryImpl: DependencyFactory, CustomizeCoordinatorsFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
    
    func makeWeeklyReportCoordinator() -> WeeklyReportCoordinator {
        return WeeklyReportCoordinator(modulesFactory: WeeklyReportModulesFactoryImpl(serviceFactory: serviceFactory))
    }
}
