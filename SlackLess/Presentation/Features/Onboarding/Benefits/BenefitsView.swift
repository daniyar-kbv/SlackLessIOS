//
//  BenefitsView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import UIKit
import SnapKit

final class BenefitsView: SLView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 40, weight: .bold)
        view.textColor = SLColors.accent1.getColor()
        view.text = SLTexts.Benefits.title.localized()
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(BenefitsTableCell.self, forCellReuseIdentifier: String(describing: BenefitsTableCell.self))
        view.register(SLTableViewSpacerCell.self, forCellReuseIdentifier: SLTableViewSpacerCell.reuseIdentifier)
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, tableView])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.spacing = 52
        return view
    }()
    
    private(set) lazy var topView = UIView()
    
    private(set) lazy var footnoteLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.Common.Footnote.assessment.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.setTitle(SLTexts.Button.continue_.localized(), for: .normal)
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
        [button, footnoteLabel, topView].forEach { addSubview($0) }
        
        button.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        
        footnoteLabel.snp.makeConstraints({
            $0.bottom.equalTo(button.snp.top).offset(-16)
            $0.horizontalEdges.equalToSuperview()
        })
        
        topView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(footnoteLabel.snp.top)
        })
        
        topView.addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.horizontalEdges.centerY.equalToSuperview()
        })
        
        tableView.snp.makeConstraints({
            $0.height.equalTo(1)
        })
    }
}
