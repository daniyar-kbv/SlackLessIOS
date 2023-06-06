//
//  UIBarButtonConfigurable.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

protocol UIBarButtonConfigurable: AnyObject {
    var backAction: (() -> Void)? { get set }
    func setBackButton(completion: @escaping (() -> Void))
}

extension UIViewController: UIBarButtonConfigurable {
    private static var backActions = [String: (() -> Void)?]()

    var backAction: (() -> Void)? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController.backActions[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController.backActions[tmpAddress] = newValue
        }
    }

    func setBackButton(completion: @escaping (() -> Void)) {
        guard let image = SLImages.NavBar.back.getImage() else { return }

        let backBarButtonItem = SLUIBarButtonItem(image: image,
                                                  style: .plain)
        { [weak self] in
            (self?.backAction ?? completion)()
        }

//        backBarButtonItem.tintColor = SLColors.carbonGrey.getColor()
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
}
