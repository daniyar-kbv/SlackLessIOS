//
//  SLLoaderView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import SnapKit
import UIKit

final class SLLoaderView: UIView {
    private let overlayColor: UIColor?
    
    private(set) lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = overlayColor ?? .white.withAlphaComponent(0.01)
        return view
    }()
    
    private(set) lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray5.getColor()?.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.alpha = 0
        return view
    }()

    private(set) lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(overlayColor: UIColor? = nil) {
        self.overlayColor = overlayColor
        
        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        backgroundView.addSubview(container)
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }

        container.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func showLoader(on view: UIView, animated: Bool = true) {
        indicatorView.startAnimating()

        view.addSubview(self)
        snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        layoutIfNeeded()

        container.snp.updateConstraints {
            $0.size.equalTo(70)
        }
        
        if animated {
            UIView.animate(withDuration: 0.1,
                           animations: { [weak self] in
                self?.container.alpha = 1
                self?.layoutIfNeeded()
            })
        } else {
            container.alpha = 1
        }
    }

    func hideLoader(animated: Bool = true) {
        container.snp.updateConstraints {
            $0.size.equalTo(40)
        }
        
        if animated {
            UIView.animate(withDuration: 0.1,
                           animations: { [weak self] in
                self?.container.alpha = 0
                self?.layoutIfNeeded()
            },
                           completion: { [weak self] didFinish in
                guard didFinish else { return }
                self?.remove()
            })
        } else {
            remove()
        }
    }
    
    private func remove() {
        removeFromSuperview()
        indicatorView.stopAnimating()
    }
}
