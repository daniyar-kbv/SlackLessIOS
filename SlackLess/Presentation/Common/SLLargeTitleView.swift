//
//  SLLargeTitleView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import UIKit
import SnapKit

final class SLLargeTitleView: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var subtitle: String? {
        didSet {
            subtitleLabel.text = subtitle
        }
    }
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.textColor = SLColors.accent1.getColor()
        return view
    }()

    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.numberOfLines = 0
        return view
    }()

    private(set) lazy var contentView = UIView()

    private(set) lazy var titlesStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 8
        view.alignment = .fill
        view.layoutMargins = .init(top: 0, left: 32, bottom: 0, right: 32)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()

    private(set) lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titlesStackView, contentView])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 32
        view.alignment = .fill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        super.addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.horizontalEdges.centerY.equalToSuperview()
        })
    }
    
    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
}
