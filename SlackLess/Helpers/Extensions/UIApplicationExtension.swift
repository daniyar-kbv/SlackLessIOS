//
//  UIApplication+Extension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

extension UIApplication {
    func getKeyWindow() -> UIWindow? {
        connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
            .last(where: { $0.isKeyWindow })
    }
    
    func set(rootViewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = getKeyWindow() else { return }
        window.rootViewController = rootViewController
        UIView.transition(with: window,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: nil)
        { _ in
            completion?()
        }
    }

    func topViewController() -> UIViewController? {
        return getKeyWindow()?.rootViewController?.topViewController()
    }
}
