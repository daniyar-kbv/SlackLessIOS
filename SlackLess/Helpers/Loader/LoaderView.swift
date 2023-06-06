//
//  LoaderView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

final class LoaderView: UIView {
    private(set) lazy var container: UIView = {
        let view = UIView()
//        view.backgroundColor = SLColors.carbonGrey.getColor()?.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.alpha = 0
        return view
    }()

    private(set) lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        addSubview(container)
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40)
        }

        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func showLoader(on view: UIView) {
        indicatorView.startAnimating()

        frame = view.frame
        view.addSubview(self)

        layoutIfNeeded()

        container.snp.updateConstraints {
            $0.size.equalTo(70)
        }

        UIView.animate(withDuration: 0.1,
                       animations: { [weak self] in
                           self?.container.alpha = 1
                           self?.layoutIfNeeded()
                       })
    }

    func hideLoader() {
        container.snp.updateConstraints {
            $0.size.equalTo(40)
        }

        UIView.animate(withDuration: 0.1,
                       animations: { [weak self] in
                           self?.container.alpha = 0
                           self?.layoutIfNeeded()
                       },
                       completion: { [weak self] finished in
                           guard finished else { return }
                           self?.removeFromSuperview()
                           self?.indicatorView.stopAnimating()
                       })
    }
}
