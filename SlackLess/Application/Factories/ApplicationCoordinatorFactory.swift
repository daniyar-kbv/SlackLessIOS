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

    init(routersFactory: RoutersFactory) {
        self.routersFactory = routersFactory
    }

    func makeOnboardingCoordinator() -> OnboardingCoordinator {
        return scoped(OnboardingCoordinator(router: routersFactory.makeMainRouter(),
                                            modulesFactory: OnboardingModulesFactoryImpl()))
    }
    
    func makeSummaryCoordinator() -> SummaryCoordinator {
        return scoped(SummaryCoordinator(router: routersFactory.makeMainRouter(),
                                         modulesFactory: SummaryModulesFactoryImpl()))
    }
}
