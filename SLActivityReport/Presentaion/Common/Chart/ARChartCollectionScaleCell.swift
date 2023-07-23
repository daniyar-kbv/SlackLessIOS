//
//  ARChartCollectionScaleCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import UIKit
import SnapKit

final class ARChartCollectionScaleCell: UICollectionViewCell {
    private var uiLaidOut = false
    
    private(set) lazy var topLineView = ARDashedView()
    
    private(set) lazy var zeroTimeView: TimeView = {
        let view = TimeView(type: .horizontal)
        view.timeLabel.text = "0"
        return view
    }()
    
    private(set) lazy var rightStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    private(set) lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [zeroTimeView, rightStackView])
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()
    
    func set(type: ARChartType, times: [TimeInterval]) {
        layoutUI(type: type)
        
        rightStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        var timesReordered = times
        
        switch type {
        case .vertical: timesReordered.reverse()
        default: break
        }
        
        for time in timesReordered {
            let timeView = TimeView(type: type)
            timeView.timeLabel.text = time.formatted(with: .abbreviated, allowedUnits: [.hour])
            rightStackView.addArrangedSubview(timeView)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func layoutUI(type: ARChartType) {
        guard !uiLaidOut else { return }
        uiLaidOut = true
        
        [topLineView, mainStackView].forEach(addSubview(_:))
        
        topLineView.snp.makeConstraints({
            $0.top.horizontalEdges.equalToSuperview()
        })
        
        mainStackView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        switch type {
        case .horizontal:
            mainStackView.axis = .horizontal
            zeroTimeView.snp.makeConstraints({
                $0.width.equalTo(20)
            })
        case .vertical:
            mainStackView.axis = .vertical
            zeroTimeView.snp.makeConstraints({
                $0.height.equalTo(20)
            })
        }
    }
}

extension ARChartCollectionScaleCell {
    final class TimeView: UIView {
        private let type: ARChartType
        
        private(set) lazy var timeLabel: UILabel = {
            let view = UILabel()
            view.textColor = SLColors.gray4.getColor()
            view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
            return view
        }()
        
        private(set) lazy var dashedLineView = ARDashedView()
        
        init(type: ARChartType) {
            self.type = type
            
            super.init(frame: .zero)
            
            layoutUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func layoutUI() {
            [timeLabel, dashedLineView].forEach(addSubview(_:))
            
            timeLabel.snp.makeConstraints({
                $0.top.right.equalToSuperview().inset(4)
            })
            
            dashedLineView.snp.makeConstraints({
                $0.right.verticalEdges.equalToSuperview()
            })
        }
    }
}
