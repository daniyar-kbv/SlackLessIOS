//
//  SLPartitionsView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-11.
//

import Foundation
import UIKit
import SnapKit

final class SLPartitionsView: UIStackView {
    private var type: `Type`
    
    private(set) lazy var firstPartitionView: UIView = {
        let view = UIView()
        switch type {
        case let .graph(type):
            if type == .vertical(isEnabled: true) {
                view.backgroundColor = SLColors.gray4.getColor()
            }
        default:
            view.backgroundColor = SLColors.accent1.getColor()
        }
        return view
    }()
    
    private(set) lazy var firstPartitionLabel: UILabel = {
        let view = UILabel()
        switch type {
        case .dasboard:
            view.textColor = SLColors.label2.getColor()
            view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        case let .graph(type):
            if type == .vertical(isEnabled: true) {
                view.textColor = SLColors.gray1.getColor()
            }
            view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        }
        return view
    }()
    
    private(set) lazy var secondPartitionView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray5.getColor()
        return view
    }()
    
    private(set) lazy var secondPartitionLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label1.getColor()
        switch type {
        case .dasboard:
            view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        default:
            view.isHidden = true
        }
        return view
    }()
    
    let dashedLineLayer = CAShapeLayer()
    
    init(type: `Type`) {
        self.type = type
        
        super.init(frame: .infinite)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = CGMutablePath()
        path.addLines(between: [.init(x: firstPartitionView.frame.minX,
                                      y: firstPartitionView.frame.minY),
                                .init(x: firstPartitionView.frame.maxX,
                                      y: firstPartitionView.frame.minY)])
        dashedLineLayer.path = path
        
        firstPartitionLabel.isHidden = firstPartitionLabel.frame.width + 16 > firstPartitionView.frame.width
        secondPartitionLabel.isHidden = secondPartitionLabel.frame.width + 16 > secondPartitionView.frame.width
    }
    
    func set(percentage: Double?, firstText: String?, secondText: String?) {
        firstPartitionLabel.text = firstText
        secondPartitionLabel.text = secondText
        
        firstPartitionView.snp.remakeConstraints({
            $0.width.equalToSuperview().multipliedBy(percentage ?? 0)
        })
    }
    
    private func layoutUI() {
        [firstPartitionView, secondPartitionView].forEach(addArrangedSubview(_:))
        layer.cornerRadius = 4
        clipsToBounds = true
        
        switch type {
        case .dasboard:
            axis = .horizontal
        case let .graph(type):
            axis = .vertical
            
            switch type {
            case .horizontal:
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                firstPartitionView.layer.cornerRadius = 4
                firstPartitionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case .vertical(isEnabled: true):
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                
                dashedLineLayer.strokeColor = SLColors.accent1.getColor()?.cgColor
                dashedLineLayer.lineWidth = 1.5
                dashedLineLayer.lineDashPattern = [4, 4]
                firstPartitionView.layer.addSublayer(dashedLineLayer)
            case .vertical(isEnabled: false):
                axis = .vertical
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                firstPartitionView.layer.cornerRadius = 4
                firstPartitionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            }
        }
        
        firstPartitionView.addSubview(firstPartitionLabel)
        firstPartitionLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        
        secondPartitionView.addSubview(secondPartitionLabel)
        secondPartitionLabel.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
}

extension SLPartitionsView {
    enum `Type`: Equatable {
        case dasboard
        case graph(`Type`)
        
        static func == (lhs: SLPartitionsView.`Type`, rhs: SLPartitionsView.`Type`) -> Bool {
            switch lhs {
            case .dasboard:
                switch rhs {
                case .dasboard: return true
                default: return false
                }
            case .graph:
                switch lhs {
                case .graph: return true
                default: return false
                }
            }
        }
        
        enum `Type`: Equatable {
            case horizontal
            case vertical(isEnabled: Bool)
        }
    }
}
