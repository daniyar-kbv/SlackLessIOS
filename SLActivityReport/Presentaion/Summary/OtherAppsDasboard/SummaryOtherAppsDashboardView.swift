//
//  SummaryOtherAppsDashboardView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-11.
//

import Foundation
import UIKit
import SnapKit

final class SummaryOtherAppsDasboardView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = SLTexts.Summary.ThirdContainer.title.localized()
        view.textColor = SLColors.label1.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label1.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private(set) lazy var topStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, timeLabel])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    private(set) lazy var partitionsView = ARPartitionsView(type: .dasboard)
    
    private(set) lazy var legendView = ARLegendView(type: .twoColor)
    
    func set(time: ARTime?) {
        partitionsView.set(maxSize: partitionsView.frame.width,
                           percentage: time?.getSlackedTotalPercentage() ?? 0.5,
                           firstText: time?.getSlackedTotalPercentageText(),
                           secondText: time?.getOtherTotalPercentageText())
        timeLabel.text = time?.total.formatted(with: .abbreviated)
        layoutUI()
    }
    
    private func layoutUI() {
        [topStackView, partitionsView, legendView].forEach(addSubview(_:))
        
        topStackView.snp.makeConstraints({
            $0.top.horizontalEdges.equalToSuperview()
        })
        
        partitionsView.snp.makeConstraints({
            $0.top.equalTo(topStackView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        })
        
        legendView.snp.makeConstraints({
            $0.top.equalTo(partitionsView.snp.bottom).offset(8)
            $0.left.bottom.equalToSuperview()
        })
    }
}
