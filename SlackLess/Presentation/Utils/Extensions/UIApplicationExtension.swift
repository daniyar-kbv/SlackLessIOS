//
//  UIApplication+Extension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

extension UIApplication {
    func setRootView(_ vc: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = keyWindow else { return }
        window.rootViewController = vc
        UIView.transition(with: window,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: nil)
        { _ in
            completion?()
        }
    }

    func topViewController() -> UIViewController? {
        return keyWindow?.rootViewController?.topViewController()
    }
}
