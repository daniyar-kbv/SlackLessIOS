//
//  RequestAuthView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit
import SnapKit

final class RequestAuthView: SLView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.textColor = SLColors.accent1.getColor()
        view.text = SLTexts.RequestAuth.title.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.RequestAuth.subtitle.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var button: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(SLImages.RequestAuth.alert.getImage(), for: .normal)
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, button])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.setCustomSpacing(16, after: titleLabel)
        view.setCustomSpacing(64, after: subtitleLabel)
        return view
    }()
    
    private(set) lazy var footnoteLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        view.textColor = SLColors.gray1.getColor()
        view.text = SLTexts.RequestAuth.footnote.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
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
        [stackView, footnoteLabel].forEach { addSubview($0) }
        
        stackView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        })
        
        button.snp.makeConstraints({
            $0.width.equalTo(270)
            $0.height.equalTo(195)
        })
        
        footnoteLabel.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
    }
}
