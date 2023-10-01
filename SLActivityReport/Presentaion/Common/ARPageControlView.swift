//
//  ARPageControlView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-06.
//

import Foundation
import UIKit

// TODO: finish or remove

final class ARPageControlView: UIView {
    private let activeSize: CGFloat = 6
    private let inactiveSize: CGFloat = 6
    private let spacing: CGFloat = 6
    private let activeColor = SLColors.accent1.getColor()
    private let inactiveColor = SLColors.gray4.getColor()
    private var circleViews = [UIView]()
    private var previousPage = 1

    var numberOfPages: Int? { didSet { set(numberOfPages: numberOfPages) } }
    var currentPage = 1 { didSet { set(currentPage: currentPage) } }

    private func set(numberOfPages: Int?) {
        guard let numberOfPages = numberOfPages,
              numberOfPages > 0
        else { return }

        snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            let width = (activeSize * 3) + (spacing * 2)
            $0.width.equalTo(width)
            $0.height.equalTo(activeSize)
        }

        for i in 0 ..< numberOfPages {
            var circleView = makeCircleView(active: i == 0)
            circleView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview().offset({
                    switch i {
                    case 0: return activeSize + spacing
                    case 1: return 0
                    case 2: return (activeSize / 2) + spacing + (numberOfPages > 3 ? inactiveSize / 2 : activeSize / 2)
                    default: return 0
                    }
                }())
            }
        }
    }

    private func set(currentPage: Int) {
        guard let numberOfPages = numberOfPages else { return }
        let currentPage = currentPage - 1
        let previousPage = previousPage - 1

        if numberOfPages > 3, currentPage > 0, currentPage < numberOfPages - 1 {}

        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.circleViews.enumerated().forEach {
                $0.1.backgroundColor = $0.0 == currentPage ? self.activeColor : self.inactiveColor
            }
            self.layoutIfNeeded()
        }
    }

    private func makeCircleView(active: Bool) -> UIView {
        var view = UIView()
        let size: CGFloat = active ? activeSize : inactiveSize

        view.backgroundColor = active ? activeColor : inactiveColor
        view.layer.cornerRadius = size / 2

        view.snp.makeConstraints {
            $0.size.equalTo(size)
        }

        return view
    }
}
