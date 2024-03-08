//
//  SurveyTableViewCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import UIKit
import SnapKit

class SurveyTableViewCell: UITableViewCell {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .semibold)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        view.layer.cornerRadius = 16
        return view
    }()
    
    private var answer: SurveyQuestion.Answer? {
        didSet {
            titleLabel.text = answer?.title
        }
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
        
        answer = nil
    }
    
    private func layoutUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview()
        })
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
    
    func set(answer: SurveyQuestion.Answer) {
        self.answer = answer
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        containerView.backgroundColor = SLColors.backgroundElevated.getColor()?.withAlphaComponent(highlighted ? 0.5 : 1)
    }
}
