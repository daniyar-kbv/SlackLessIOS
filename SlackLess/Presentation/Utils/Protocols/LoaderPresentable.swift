//
//  LoaderPresentable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-23.
//

import Foundation
import UIKit
import SnapKit

protocol LoaderPresentable {
    func showLoader(on view: UIView?, animated: Bool)
    func hideLoader(animated: Bool)
}

extension UIViewController: LoaderPresentable {
    fileprivate static var loaderViews = [String:SLLoaderView]()
    
    var loaderView: SLLoaderView? {
            get {
                let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
                return UIViewController.loaderViews[tmpAddress] ?? nil
            }
            set(newValue) {
                let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
                UIViewController.loaderViews[tmpAddress] = newValue
            }
        }
    
    func showLoader(on view: UIView? = nil, animated: Bool = true) {
        guard loaderView == nil else { return }
        let loaderView = SLLoaderView()
        self.loaderView = loaderView
        loaderView.showLoader(on: view ?? self.view, animated: animated)
    }
    
    func hideLoader(animated: Bool = true) {
        loaderView?.hideLoader(animated: animated)
        loaderView = nil
    }
}
