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
                addDashedLine(on: .top)
                firstPartitionView.backgroundColor = SLColors.accent1.getColor()
                firstPartitionLabel.textColor = SLColors.gray1.getColor()
                firstPartitionView.layer.cornerRadius = 4
            } else {
                removeDashedLine(on: .top)
                firstPartitionView.backgroundColor = SLColors.gray4.getColor()
                firstPartitionLabel.textColor = SLColors.label2.getColor()
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
            guard !isEnabled else { break }
            redrawDashedLine(on: .top,
                             strokeColor: SLColors.accent1.getColor()?.cgColor,
                             lineWidth: 1.5,
                             lineDashPattern: [4, 4])
        default: break
        }
        
        firstPartitionLabel.isHidden = firstPartitionLabel.frame.width + 16 > firstPartitionView.frame.width
        secondPartitionLabel.isHidden = secondPartitionLabel.frame.width + 16 > secondPartitionView.frame.width
    }
    
    func set(maxSize: CGFloat,
             percentage: Double,
             firstText: String?,
             secondText: String?) {
        firstPartitionLabel.text = firstText
        secondPartitionLabel.text = secondText
        
        switch type {
        case .dasboard:
            firstPartitionView.snp.remakeConstraints({
                $0.width.equalTo(maxSize*percentage)
            })
        case .graph(.horizontal):
            snp.remakeConstraints({
                $0.width.equalTo(maxSize)
            })
            
            firstPartitionView.snp.remakeConstraints({
                $0.width.equalTo(maxSize*percentage)
            })
        case .graph(.vertical):
            snp.remakeConstraints({
                $0.height.equalTo(maxSize)
            })
            
            firstPartitionView.snp.remakeConstraints({
                $0.height.equalTo(maxSize*percentage)
            })
        }
    }
    
    private func layoutUI() {
        [firstPartitionView, secondPartitionView].forEach(addArrangedSubview(_:))
        layer.cornerRadius = 4
        clipsToBounds = true
        
        switch type {
        case .dasboard:
            axis = .horizontal
        case let .graph(type):
            
            switch type {
            case .horizontal:
                axis = .horizontal
                layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                firstPartitionView.layer.cornerRadius = 4
                firstPartitionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            case .vertical:
                addDashedLine(on: .top)
                axis = .vertical
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
                firstPartitionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
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
