//
//  ApplicationCoordinatorFactory.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

protocol ApplicationCoordinatorFactory: AnyObject {
    func makeOnboardingCoordinator() -> OnboardingCoordinator
    func makeSummaryCoordinator() -> SummaryCoordinator
}

final class ApplicationCoordinatorFactoryImpl: DependencyFactory, ApplicationCoordinatorFactory {
    private let routersFactory: RoutersFactory
    private let serviceFactory: ServiceFactory

    init(routersFactory: RoutersFactory,
         serviceFactory: ServiceFactory) {
        self.routersFactory = routersFactory
        self.serviceFactory = serviceFactory
    }

    func makeOnboardingCoordinator() -> OnboardingCoordinator {
        return scoped(OnboardingCoordinator(router: routersFactory.makeMainRouter(),
                                            modulesFactory: OnboardingModulesFactoryImpl(serviceFactory: serviceFactory)))
    }
    
    func makeSummaryCoordinator() -> SummaryCoordinator {
        return scoped(SummaryCoordinator(router: routersFactory.makeMainRouter(),
                                         modulesFactory: SummaryModulesFactoryImpl()))
    }
}
