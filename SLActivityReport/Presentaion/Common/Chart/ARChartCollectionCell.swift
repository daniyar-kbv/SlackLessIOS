//
//  ChartCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import UIKit
import SnapKit

final class ARChartCollectionBarCell: UICollectionViewCell {
    private var uiLaidOut = false
    private var type: ARChartType?
    
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.gray4.getColor()
        return view
    }()
    
    private(set) lazy var dateView = UIView()
    
    private(set) lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray4.getColor()
        return view
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label1.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private(set) lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray5.getColor()
        return view
    }()
    
    private(set) var barView: ARPartitionsView?
    
    private(set) lazy var barStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 4
        view.alignment = .center
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let type = type else { return }
        
        switch type {
        case .horizontal:
            redrawDashedLine(on: .bottom)
        case .vertical:
            redrawDashedLine(on: .left)
        }
    }
    
    func set(type: ARChartType, item: GraphRepresentable, size: CGFloat) {
        self.type = type
        layoutUI()
        
        dateLabel.text = item.getDateText()
        timeLabel.text = item.getTotalTimeFormatted()
        
        switch type {
        case .horizontal:
            barView?.snp.remakeConstraints({
                $0.height.equalToSuperview().inset(4)
                $0.width.equalTo(size)
            })
            
            barView?.set(percentage: item.getPercentage(),
                         firstText: item.getSlackedTimeFormatted(),
                         secondText: nil)
        case .vertical:
            barView?.set(percentage: item.getPercentage(),
                         firstText: item.getSlackedTimeFormatted(),
                         secondText: nil)
        }
    }
    
    private func layoutUI() {
        guard !uiLaidOut,
              let type = type
        else { return }
        uiLaidOut = true
        
        switch type {
        case .horizontal: barView = ARPartitionsView(type: .graph(.horizontal))
        case .vertical: barView = ARPartitionsView(type: .graph(.vertical))
        }
        
        [dateLabel, separatorView].forEach(dateView.addSubview(_:))
        
        barStackView.distribution = .fill
        
        switch type {
        case .horizontal:
            addDashedLine(on: .bottom)
            
            dateLabel.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
            
            [dateView, barStackView].forEach(addSubview(_:))
            
            dateView.snp.makeConstraints({
                $0.left.verticalEdges.equalToSuperview()
                $0.width.equalTo(20).priority(.required)
            })
            
            dateLabel.snp.makeConstraints({
                $0.top.equalToSuperview().offset(4)
                $0.centerX.equalToSuperview()
            })
            
            separatorView.snp.makeConstraints({
                $0.right.verticalEdges.equalToSuperview()
                $0.width.equalTo(0.5)
            })
            
            barStackView.snp.makeConstraints({
                $0.left.equalTo(dateView.snp.right)
                $0.verticalEdges.equalToSuperview()
                $0.right.equalToSuperview().offset(-4)
            })
            
            [barView!, lineView, timeLabel].forEach(barStackView.addArrangedSubview(_:))
            barStackView.axis = .horizontal
            
            lineView.snp.makeConstraints({
                $0.height.equalTo(0.4)
            })
        case .vertical:
            dateLabel.font = SLFonts.primary.getFont(ofSize: 8, weight: .regular)
            
            [barStackView, dateView].forEach(addSubview(_:))
            
            dateView.snp.makeConstraints({
                $0.height.equalTo(20)
            })
            
            dateLabel.snp.makeConstraints({
                $0.bottom.equalToSuperview().offset(-4)
                $0.centerX.equalToSuperview()
            })
            
            [timeLabel, lineView, barView!].forEach(barStackView.addArrangedSubview(_:))
            barStackView.axis = .vertical
            
            barStackView.snp.makeConstraints({
                $0.bottom.verticalEdges.equalToSuperview()
                $0.top.equalToSuperview().offset(4)
            })
            
            lineView.snp.makeConstraints({
                $0.width.equalTo(0.5)
            })
            
            barView!.snp.makeConstraints({
                $0.width.equalToSuperview().inset(4)
            })
        }
    }
}
