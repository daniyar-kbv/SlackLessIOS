//
//  ApplicationPagesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol ApplicationModulesFactory: AnyObject {
    func makeSLTabBarController() -> SLTabBarController
}

final class ApplicationModulesFactoryImpl: DependencyFactory, ApplicationModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }
}

//  MARK: ABTabBar

extension ApplicationModulesFactoryImpl {
    func makeSLTabBarController() -> SLTabBarController {
        return shared(.init(viewModel: makeSLTabBarViewModel()))
    }

    private func makeSLTabBarViewModel() -> SLTabBarViewModel {
        return shared(SLTabBarViewModelImpl())
    }
}
