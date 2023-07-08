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
    
    func add(controller: UIViewController, with controllerView: UIView, to view: UIView) {
        addChild(controller)
        view.addSubview(controllerView)
        controllerView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        controller.didMove(toParent: self)
    }
}
