//
//  SurveyView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-06.
//

import Foundation
import UIKit
import SnapKit

final class SurveyView: SLView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.textColor = SLColors.accent1.getColor()
        view.text = question.title
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        view.textColor = SLColors.gray1.getColor()
        view.text = question.subtitle
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SurveyTableViewCell.self, forCellReuseIdentifier: String(describing: SurveyTableViewCell.self))
        view.rowHeight = 68
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, tableView])
        view.setCustomSpacing(16, after: titleLabel)
        view.setCustomSpacing(32, after: subtitleLabel)
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        return view
    }()
    
    private let question: SurveyQuestion
    
    init(question: SurveyQuestion) {
        self.question = question
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        })
    }
    
    func setTableView(height: CGFloat) {
        tableView.snp.remakeConstraints({
            $0.width.equalToSuperview()
            $0.height.equalTo(height)
        })
    }
}
