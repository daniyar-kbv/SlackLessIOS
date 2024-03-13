//
//  BenefitsTableCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import UIKit
import SnapKit

final class BenefitsTableCell: UITableViewCell {
    private(set) lazy var iconView = UIImageView()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .semibold)
        view.textColor = SLColors.label1.getColor()
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private(set) lazy var labelsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    private var benefitType: BenefitType? {
        didSet { reload() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        benefitType = nil
    }
    
    func set(benefitType: BenefitType?) {
        self.benefitType = benefitType
    }
    
    private func layoutUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        [iconView, labelsStack].forEach { contentView.addSubview($0) }
        
        iconView.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
            $0.size.equalTo(32)
        })
        
        labelsStack.snp.makeConstraints({
            $0.left.equalTo(iconView.snp.right).offset(16)
            $0.right.verticalEdges.equalToSuperview()
        })
    }
    
    private func reload() {
        iconView.image = benefitType?.image
        titleLabel.text = benefitType?.title
        subtitleLabel.text = benefitType?.subtitle
    }
}
