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
    private var type: `Type`?
    
    private(set) lazy var firstPartitionView: UIView = {
        let view = UIView()
        switch type {
        case let .graph(info):
            if info.type == .vertical(isEnabled: true) {
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
        case let .dasboard(info):
            view.textColor = SLColors.label2.getColor()
            view.text = "\(info.firstPercentage ?? 0)%"
        case let .graph(info):
            if info.type == .vertical(isEnabled: true) {
                view.textColor = SLColors.gray1.getColor()
            }
            view.text = "\(info.time.getHours())h \(info.time.getRemaindingMinutes())m"
        case .none: break
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
        case let .dasboard(info):
            view.text = "\(info.secondPercentage ?? 0)%"
        default: view.isHidden = true
        }
        return view
    }()
    
    let dashedLineLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = CGMutablePath()
        path.addLines(between: [.init(x: firstPartitionView.frame.minX,
                                      y: firstPartitionView.frame.minY),
                                .init(x: firstPartitionView.frame.maxX,
                                      y: firstPartitionView.frame.minY)])
        dashedLineLayer.path = path
    }
    
    func set(type: `Type`) {
        self.type = type
        layoutUI()
    }
    
    private func layoutUI() {
        [firstPartitionView, secondPartitionView].forEach(addArrangedSubview(_:))
        layer.cornerRadius = 4
        clipsToBounds = true
        
        switch type {
        case let .dasboard(info):
            axis = .horizontal
            print(CGFloat((info.firstPercentage ?? 0))/100)
            firstPartitionView.snp.makeConstraints({
                $0.width.equalToSuperview().multipliedBy(CGFloat((info.firstPercentage ?? 0))/100)
            })
        case let .graph(info):
            axis = .vertical
            
            switch info.type {
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
        case .none: break
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
        case dasboard(DasboardInfo)
        case graph(GraphInfo)
        
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
    }
    
    struct DasboardInfo {
        let firstPercentage: Int?
        let secondPercentage: Int?
    }
    
    struct GraphInfo {
        let type: `Type`
        let time: Int
        let percentage: Int
        
        enum `Type`: Equatable {
            case horizontal
            case vertical(isEnabled: Bool)
        }
    }
}
