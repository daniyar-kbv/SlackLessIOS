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
    func showLoader(on view: UIView?)
    func hideLoader()
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
    
    func showLoader(on view: UIView? = nil) {
        guard loaderView == nil else { return }
        let loaderView = SLLoaderView()
        self.loaderView = loaderView
        loaderView.showLoader(on: view ?? self.view)
    }
    
    func hideLoader() {
        loaderView?.hideLoader()
        loaderView = nil
    }
}
