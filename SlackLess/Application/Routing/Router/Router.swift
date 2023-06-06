//
//  Router.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

protocol Router {
    var didFinish: (() -> Void)? { get }
    func set(navigationController: SLNavigationController)
    func getNavigationController() -> SLNavigationController

    func push(viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func popToRootViewController(animated: Bool)
    func pop(to viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func dismiss(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismissAll(animated: Bool, completion: (() -> Void)?)
    func show(_ viewController: UIViewController)
}

final class MainRouter: Router {
    var didFinish: (() -> Void)?

    var navigationController: SLNavigationController! {
        didSet {
            totalNumberOfPages = navigationController.viewControllers.count
            initialNumberOfPages = totalNumberOfPages
        }
    }

    private var totalNumberOfPages: Int = 0
    private var initialNumberOfPages: Int = 0

    private lazy var didTapOnBack: (() -> Void) = { [weak self] in
        self?.pop(animated: true)
    }

    private let navigationLogic: NavigationLogic
    private let isRootRouter: Bool

    init(isRootRouter: Bool, navigationLogic: NavigationLogic) {
        self.isRootRouter = isRootRouter
        self.navigationLogic = navigationLogic
    }

    func set(navigationController: SLNavigationController) {
        self.navigationController = navigationController
        self.navigationController.addObserver(self)
    }

    func getNavigationController() -> SLNavigationController {
        return navigationController
    }

    func push(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
        totalNumberOfPages = navigationController.viewControllers.count
    }

    func pop(to viewController: UIViewController, animated: Bool) {
        navigationController.popToViewController(viewController, animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.topViewController()?.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.topViewController()?.dismiss(animated: animated, completion: completion)
    }

    func dismiss(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let thisAnimated = navigationController.topViewController()?.presentingViewController?.presentingViewController == viewController && animated

        navigationController.topViewController()?
            .dismiss(animated: thisAnimated) { [weak self,
                                                weak viewController] in
                    guard let viewController = viewController,
                          self?.navigationController.topViewController() != viewController
                    else {
                        completion?()
                        return
                    }

                    self?.dismiss(to: viewController, animated: animated, completion: completion)
            }
    }

    func dismissAll(animated: Bool, completion: (() -> Void)?) {
        let isLast = navigationController.topViewController()?.presentingViewController?.presentingViewController == nil
        let thisAnimated = isLast && animated

        navigationController.topViewController()?
            .dismiss(animated: thisAnimated) { [weak self] in
                guard !isLast else {
                    completion?()
                    return
                }

                self?.dismissAll(animated: animated, completion: completion)
            }
    }

    func show(_ viewController: UIViewController) {
        navigationController.show(viewController, sender: nil)
    }
}

extension MainRouter: SLNavigationControllerDelegate {
    func SLNavigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController) {
        let willPush: Bool = totalNumberOfPages < navigationController.viewControllers.count

        if willPush {
            let configuration = navigationLogic.configure(viewController: viewController, in: navigationController)
            setConfiguration(configuration, for: viewController)
        }
    }

    func SLNavigationController(_ navigationController: UINavigationController, didShow vc: UIViewController) {
        let didPop: Bool = totalNumberOfPages > navigationController.viewControllers.count

        let isNonChangeable = totalNumberOfPages == navigationController.viewControllers.count
        guard !isNonChangeable else { return }

        totalNumberOfPages = navigationController.viewControllers.count

        if didPop {
            let shouldCommitSuicide: Bool = totalNumberOfPages == initialNumberOfPages && !isRootRouter
            if shouldCommitSuicide {
                didFinish?()
            }
            let configuration = navigationLogic.configure(viewController: vc, in: navigationController)
            setConfiguration(configuration, for: vc)
        }
    }

    private func setConfiguration(_ configuration: BarButtonConfiguration, for viewController: UIViewController) {
        switch configuration {
        case .withBackButton:
            viewController.setBackButton(completion: didTapOnBack)
            navigationController.interactivePopGestureRecognizer?.delegate = viewController as? UIGestureRecognizerDelegate
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        case .none:
            viewController.navigationItem.setHidesBackButton(true, animated: true)
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
