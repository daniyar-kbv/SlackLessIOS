//
//  ARPartitionsView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-11.
//

import Foundation
import UIKit
import SnapKit

final class ARPartitionsView: UIStackView {
    private var type: ViewType
    
    var isEnabled = true {
        didSet {
            if isEnabled {
                firstPartitionView.removeDashedLine(on: .top)
                firstPartitionView.backgroundColor = SLColors.accent1.getColor()
                firstPartitionLabel.textColor = SLColors.white.getColor()
                firstPartitionView.layer.cornerRadius = 4
            } else {
                firstPartitionView.addDashedLine(on: .top)
                firstPartitionView.backgroundColor = SLColors.gray4.getColor()
                firstPartitionLabel.textColor = SLColors.gray1.getColor()
                firstPartitionView.layer.cornerRadius = 0
            }
        }
    }
    
    private(set) lazy var firstPartitionView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.accent1.getColor()
        return view
    }()
    
    private(set) lazy var firstPartitionLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label2.getColor()
        view.numberOfLines = 1
        switch type {
        case .dasboard:
            view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        case let .graph(type):
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
        view.numberOfLines = 1
        switch type {
        case .dasboard:
            view.font = SLFonts.primary.getFont(ofSize: 13, weight: .regular)
        default:
            view.isHidden = true
        }
        return view
    }()
    
    init(type: ViewType) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch type {
        case .graph(.vertical):
            firstPartitionView.redrawDashedLine(on: .top,
                                                strokeColor: SLColors.accent1.getColor()?.cgColor,
                                                lineWidth: 1.5,
                                                lineDashPattern: [4, 4])
        default: break
        }
        
        switch type {
        case .dasboard, .graph(.horizontal):
            let firstTextSize = (firstPartitionLabel.text?.width(withConstrainedHeight: 100, font: firstPartitionLabel.font) ?? 0) + 8
            let secondTextSize = (secondPartitionLabel.text?.width(withConstrainedHeight: 100, font: secondPartitionLabel.font) ?? 0) + 8
            firstPartitionLabel.isHidden = firstTextSize > firstPartitionView.frame.width
            secondPartitionLabel.isHidden = secondTextSize > secondPartitionView.frame.width
        case .graph(.vertical):
            let firstTextSize = (firstPartitionLabel.text?.height(withConstrainedWidth: 100, font: firstPartitionLabel.font) ?? 0) + 8
            let secondTextSize = (secondPartitionLabel.text?.height(withConstrainedWidth: 100, font: secondPartitionLabel.font) ?? 0) + 8
            firstPartitionLabel.isHidden = firstTextSize > firstPartitionView.frame.height
            secondPartitionLabel.isHidden = secondTextSize > secondPartitionView.frame.height
        }
    }
    
    func set(percentage: Double,
             firstText: String?,
             secondText: String?) {
        firstPartitionLabel.text = firstText
        secondPartitionLabel.text = secondText
        
        switch type {
        case .dasboard, .graph(.horizontal):
            firstPartitionView.snp.remakeConstraints({
                $0.width.equalToSuperview().multipliedBy(percentage)
            })
        case .graph(.vertical):
            firstPartitionView.snp.remakeConstraints({
                $0.height.equalToSuperview().multipliedBy(percentage)
            })
        }
    }
    
    private func layoutUI() {
        layer.cornerRadius = 4
        clipsToBounds = true
        alignment = .fill
        backgroundColor = secondPartitionView.backgroundColor
        
        switch type {
        case .dasboard, .graph(.horizontal):
            [firstPartitionView, secondPartitionView].forEach(addArrangedSubview(_:))
        case .graph(.vertical):
            [secondPartitionView, firstPartitionView].forEach(addArrangedSubview(_:))
        }
        
        switch type {
        case .dasboard:
            axis = .horizontal
        case let .graph(type):
            switch type {
            case .horizontal:
                axis = .horizontal
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
                firstPartitionView.layer.cornerRadius = 4
                firstPartitionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .vertical:
                addDashedLine(on: .top)
                axis = .vertical
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                firstPartitionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                firstPartitionView.layer.cornerRadius = 4
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

extension ARPartitionsView {
    enum ViewType: Equatable {
        case dasboard
        case graph(GraphViewType)
        
        static func == (lhs: ARPartitionsView.ViewType, rhs: ARPartitionsView.ViewType) -> Bool {
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
        
        enum GraphViewType: Equatable {
            case horizontal
            case vertical
        }
    }
}
