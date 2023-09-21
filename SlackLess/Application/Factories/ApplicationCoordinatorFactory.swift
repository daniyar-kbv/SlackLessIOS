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
    func makeProgressCoordinator() -> ProgressCoordinator
    func makeCustomizeCoordinator() -> CustomizeCoordinator
}

final class ApplicationCoordinatorFactoryImpl: DependencyFactory, ApplicationCoordinatorFactory {
    private let routersFactory: RoutersFactory
    private let serviceFactory: ServiceFactory
    private let helpersFactory: HelpersFactory

    init(routersFactory: RoutersFactory,
         serviceFactory: ServiceFactory,
         helpersFactory: HelpersFactory)
    {
        self.routersFactory = routersFactory
        self.serviceFactory = serviceFactory
        self.helpersFactory = helpersFactory
    }

    func makeOnboardingCoordinator() -> OnboardingCoordinator {
        return scoped(OnboardingCoordinator(router: routersFactory.makeMainRouter(),
                                            modulesFactory: OnboardingModulesFactoryImpl(serviceFactory: serviceFactory)))
    }

    func makeSummaryCoordinator() -> SummaryCoordinator {
        return scoped(SummaryCoordinator(router: routersFactory.makeMainRouter(),
                                         modulesFactory: SummaryModulesFactoryImpl(serviceFactory: serviceFactory)))
    }

    func makeProgressCoordinator() -> ProgressCoordinator {
        return scoped(ProgressCoordinator(router: routersFactory.makeMainRouter(),
                                          modulesFactory: ProgressModulesFactoryImpl(serviceFactory: serviceFactory)))
    }

    func makeCustomizeCoordinator() -> CustomizeCoordinator {
        return scoped(CustomizeCoordinator(router: routersFactory.makeMainRouter(),
                                           modulesFactory: CustomizeModulesFactoryImpl()))
    }
}
