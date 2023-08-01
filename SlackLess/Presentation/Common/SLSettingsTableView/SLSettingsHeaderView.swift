//
//  SLSettingsHeaderView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation
import UIKit
import SnapKit

final class SLSettingsHeaderView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.textColor = SLColors.label1.getColor()
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-4)
            $0.top.right.equalToSuperview()
        })
    }
}
