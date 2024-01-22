//
//  SLTitleChevronView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-15.
//

import Foundation
import SnapKit
import UIKit


final class SLTitleChevronView: UIStackView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.gray1.getColor()
        return view
    }()
    
    private(set) lazy var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.Common.Arrows.Chevron.right.getImage()
        return view
    }()
    
    init(title: String? = nil) {
        super.init(frame: .zero)
    
        [titleLabel, chevronImageView].forEach { addArrangedSubview($0) }
        axis = .horizontal
        alignment = .center
        titleLabel.text = title
        
        chevronImageView.snp.makeConstraints({
            $0.size.equalTo(16)
        })
            
    }
    
    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
