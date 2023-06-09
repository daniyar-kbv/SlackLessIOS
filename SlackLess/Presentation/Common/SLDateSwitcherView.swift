//
//  SLDateSwitcherView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class SLDateSwitcherView: UIStackView {
    private(set) lazy var leftArrowView: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.Common.Arrows.Circle.left.getImage()
        return view
    }()
    
    private(set) lazy var rightArrowView: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.Common.Arrows.Circle.right.getImage()
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
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        
        [leftArrowView, titleLabel, rightArrowView].forEach(addArrangedSubview(_:))
        
        [leftArrowView, rightArrowView].forEach({ view in
            view.snp.makeConstraints({ make in
                make.size.equalTo(28)
            })
        })
    }
}

extension SLDateSwitcherView {
    func set(date: String) {
        titleLabel.text = dateÇ
    }
    
    func setLeftArrow(enabled: Bool) {
        leftArrowView.alpha = enabled ? 1 : 0.5
    }
    
    func setRightArrow(enabled: Bool) {
        leftArrowView.alpha = enabled ? 1 : 0.5
    }
}
