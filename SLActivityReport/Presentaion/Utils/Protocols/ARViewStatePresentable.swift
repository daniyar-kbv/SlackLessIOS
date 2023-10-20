//
//  ARViewStatePresentable.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-10-18.
//

import Foundation
import UIKit
import SnapKit

protocol ARStatePresentable: UIViewController {
    func update(state: ARViewState, view: UIView?)
}

extension UIViewController: ARStatePresentable {
    fileprivate static var overlayView = [String:OverlayView]()
    
    fileprivate var overlayView: OverlayView? {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            return UIViewController.overlayView[tmpAddress] ?? nil
        }
        set(newValue) {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            UIViewController.overlayView[tmpAddress] = newValue
        }
    }
    
    func update(state: ARViewState, view: UIView? = nil) {
        switch state {
        case .loading:
            showLoading(on: view ?? self.view)
        case .loaded:
            hideLoading()
        }
    }
    
    private func showLoading(on view: UIView) {
        guard overlayView == nil else { return }
        
        let overlayView = OverlayView()
        self.overlayView = overlayView
        
        view.addSubview(overlayView)
        overlayView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        showLoader(on: overlayView)
    }
    
    private func hideLoading() {
        guard let overlayView = overlayView else { return }
        
        hideLoader()
        
        UIView.animate(
            withDuration: 0.1,
            animations: {
                overlayView.alpha = 0
            }, completion: { [weak self] didFinished in
                guard didFinished else { return }
                self?.overlayView?.removeFromSuperview()
                self?.overlayView = nil
            })
    }
}

extension UIViewController {
    fileprivate final class OverlayView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = SLColors.background1.getColor()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
