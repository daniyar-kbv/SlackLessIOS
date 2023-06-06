//
//  RoutersFactory.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

final class BaseNavigationLogic: NavigationLogic {
    func configure(viewController _: UIViewController, in navigationController: UINavigationController) -> BarButtonConfiguration {
        if navigationController.viewControllers.count > 1 {
            return .withBackButton
        }

        return .none
    }
}

protocol RoutersFactory: AnyObject {
    func makeMainRouter() -> Router
}

final class RoutersFactoryImpl: DependencyFactory, RoutersFactory {
    func makeMainRouter() -> Router {
        return scoped(MainRouter(isRootRouter: true, navigationLogic: BaseNavigationLogic()))
    }
}
