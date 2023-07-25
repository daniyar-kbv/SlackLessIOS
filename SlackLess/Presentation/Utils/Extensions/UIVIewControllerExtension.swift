//
//  UIVIewControllerExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit
import SwiftUI
import SnapKit

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
    
    func add(controller: UIViewController, to view: UIView? = nil, with constraints: ((ConstraintMaker) -> Void)? = nil) {
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        var containerView: UIView!
        if let view = view {
            containerView = view
        } else {
            containerView = self.view
        }
        
        containerView.addSubview(controller.view)
        
        if let constraints = constraints {
            controller.view.snp.makeConstraints(constraints)
        } else {
            controller.view.snp.makeConstraints({
                $0.top.equalTo(containerView.safeAreaLayoutGuide.snp.top)
                $0.bottom.horizontalEdges.equalToSuperview()
            })
        }

        addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func remove(controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.removeFromParent()
        controller.view.removeFromSuperview()
    }
}
