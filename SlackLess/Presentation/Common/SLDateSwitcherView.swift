//
//  SLDateSwitcherView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import SnapKit
import UIKit

final class SLDateSwitcherView: UIStackView {
    private(set) lazy var leftButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.left.getImage(), for: .normal)
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.left.getImage()?.withAlpha(0.5), for: .highlighted)
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.left.getImage()?.withAlpha(0.5), for: .disabled)
        return view
    }()

    private(set) lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.right.getImage(), for: .normal)
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.right.getImage()?.withAlpha(0.5), for: .highlighted)
        view.setBackgroundImage(SLImages.Common.Arrows.Circle.right.getImage()?.withAlpha(0.5), for: .disabled)
        return view
    }()

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .bold)
        view.textColor = SLColors.label1.getColor()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center

        [leftButton, titleLabel, rightButton].forEach(addArrangedSubview(_:))

        [leftButton, rightButton].forEach { view in
            view.snp.makeConstraints { make in
                make.size.equalTo(28)
            }
        }
    }
}

extension SLDateSwitcherView {
    func set(date: String) {
        titleLabel.text = date
    }

    func setLeftArrow(enabled: Bool) {
        leftButton.alpha = enabled ? 1 : 0.5
    }

    func setRightArrow(enabled: Bool) {
        leftButton.alpha = enabled ? 1 : 0.5
    }
}
