//
//  UIVIewControllerExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import SnapKit
import SwiftUI
import UIKit

extension UIViewController {
    func topViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController()
        }

        if let tabController = self as? UITabBarController,
           let selected = tabController.selectedViewController
        {
            return selected.topViewController()
        }

        if let presented = presentedViewController {
            return presented.topViewController()
        }
        return self
    }

    func dismiss(to viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let thisAnimated = presentingViewController?.presentingViewController == viewController && animated

        dismiss(animated: thisAnimated) { [weak self,
                                           weak viewController] in
                guard let viewController = viewController,
                      self != viewController
                else {
                    completion?()
                    return
                }

                self?.dismiss(to: viewController, animated: animated, completion: completion)
        }
    }

    func dismissAll(animated: Bool, completion: (() -> Void)?) {
        let presentingViewController = presentingViewController
        let isLast = presentingViewController?.presentingViewController == nil
        let thisAnimated = isLast && animated

        dismiss(animated: thisAnimated) {
            guard !isLast else {
                completion?()
                return
            }

            presentingViewController?.dismissAll(animated: animated, completion: completion)
        }
    }
}

extension UIViewController {
    func add(controller: UIViewController, to view: UIView? = nil, with constraints: ((ConstraintMaker) -> Void)? = nil) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false

        if let view = view {
            view.addSubview(controller.view)

            if let constraints = constraints {
                controller.view.snp.makeConstraints(constraints)
            } else {
                controller.view.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
        }

        addChild(controller)
        controller.didMove(toParent: self)
    }

    func add(controller: UIViewController, addView: () -> Void) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        addView()
        addChild(controller)
        controller.didMove(toParent: self)
    }

    func remove(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
    }
}
