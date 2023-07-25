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
    
    private(set) lazy var dashedLineLayer = CAShapeLayer()
    
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
    
    private(set) lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
//    Tech debt: refactor with DashedView
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let type = type else { return }

        let path = CGMutablePath()
        switch type {
        case .horizontal:
            path.addLines(between: [.init(x: mainStackView.frame.minX,
                                          y: mainStackView.frame.minY),
                                    .init(x: mainStackView.frame.maxX,
                                          y: mainStackView.frame.minY)])
        case .vertical:
            path.addLines(between: [.init(x: mainStackView.frame.maxX,
                                          y: mainStackView.frame.minY),
                                    .init(x: mainStackView.frame.maxX,
                                          y: mainStackView.frame.maxY)])
        }

        dashedLineLayer.path = path
    }
    
    func set(type: ARChartType, item: GraphRepresentable, maxTime: TimeInterval, maxProportions: Double) {
        self.type = type
        layoutUI()
        
        dateLabel.text = item.getDateText()
        timeLabel.text = item.getTotalTimeFormatted()
        
        switch type {
        case .horizontal:
            barView?.set(maxSize: barStackView.frame.width*maxProportions,
                         percentage: item.getPercentage(),
                         firstText: item.getSlackedTimeFormatted(),
                         secondText: nil)
        case .vertical:
            let maxTextHeight = item.getTotalTimeFormatted()?.height(withConstrainedWidth: 100, font: timeLabel.font) ?? 0
            let maxSize = barStackView.frame.height - maxTextHeight - 20
            barView?.set(maxSize: maxSize,
                         percentage: item.getPercentage(),
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
        
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        dateView.addSubview(dateLabel)
        
        dashedLineLayer.strokeColor = SLColors.gray4.getColor()?.cgColor
        dashedLineLayer.lineWidth = 0.5
        dashedLineLayer.lineDashPattern = [2, 2]
        mainStackView.layer.addSublayer(dashedLineLayer)
        
        switch type {
        case .horizontal:
            dateLabel.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
            
            [dateView, barStackView].forEach(mainStackView.addArrangedSubview(_:))
            mainStackView.axis = .horizontal
            
            dateView.snp.makeConstraints({
                $0.width.equalTo(20).priority(.required)
            })
            
            dateLabel.snp.makeConstraints({
                $0.top.equalToSuperview().offset(4)
                $0.centerX.equalToSuperview()
            })
            
            [barView!, lineView, timeLabel].forEach(barStackView.addArrangedSubview(_:))
            barStackView.axis = .horizontal
            
            barStackView.snp.makeConstraints({
                $0.left.verticalEdges.equalToSuperview()
                $0.right.equalToSuperview().offset(-4)
            })
            
            lineView.snp.makeConstraints({
                $0.height.equalTo(0.5)
            })
            
            barView!.snp.makeConstraints({
                $0.height.equalToSuperview().inset(4)
            })
        case .vertical:
            dateLabel.font = SLFonts.primary.getFont(ofSize: 8, weight: .regular)
            
            [barStackView, dateView].forEach(mainStackView.addArrangedSubview(_:))
            mainStackView.axis = .vertical
            
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
