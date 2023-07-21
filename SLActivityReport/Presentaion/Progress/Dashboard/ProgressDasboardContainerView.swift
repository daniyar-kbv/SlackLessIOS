//
//  ProgressDasboardContainer.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit
import SnapKit

final class ProgressDasboardContainerView: UIView {
    private let type: ViewType
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = type.textColor
        view.font = type.titleFont
        view.text = type.title
        return view
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.textColor = type.textColor
        view.font = type.timeFont
        view.adjustsFontSizeToFitWidth = true
        view.numberOfLines = 1
        return view
    }()
    
    private(set) lazy var changeView = ProgressDashboardChangeView()
    
    init(type: ViewType) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = type.backgroundColor
        layer.cornerRadius = 8
        
        snp.makeConstraints({ [weak self] in
            guard let self = self else { return }
            $0.size.equalTo(type.size)
        })
        
        [titleLabel, timeLabel, changeView].forEach(addSubview(_:))
        
        titleLabel.snp.makeConstraints({
            $0.top.left.equalToSuperview().offset(16)
        })
        
        timeLabel.snp.makeConstraints({
            $0.horizontalEdges.bottom.equalToSuperview().inset(16)
        })
        
        changeView.snp.makeConstraints({
            $0.top.right.equalToSuperview().inset(-4)
        })
    }
    
    func set(time: TimeInterval, previousTime: TimeInterval?) {
        timeLabel.text = time.formatted(with: .abbreviated)
        changeView.set(change: previousTime != nil ? (time/previousTime!)-1 : nil)
    }
}

extension ProgressDasboardContainerView {
    enum ViewType {
        case first
        case second
        case third
        
        var title: String {
            switch self {
            case .first: return SLTexts.Progress.Dashboard.firstTitle.localized()
            case .second: return SLTexts.Progress.Dashboard.secondTitle.localized()
            case .third: return SLTexts.Progress.Dashboard.thirdTitle.localized()
            }
        }
        
        var backgroundColor: UIColor? {
            switch self {
            case .first: return SLColors.accent1.getColor()
            case .second, .third: return SLColors.backgroundElevated.getColor()
            }
        }
        
        var textColor: UIColor? {
            switch self {
            case .first: return SLColors.label2.getColor()
            case .second, .third: return SLColors.label1.getColor()
            }
        }
        
        var titleFont: UIFont {
            switch self {
            case .first: return SLFonts.primary.getFont(ofSize: 16, weight: .medium)
            case .second, .third: return SLFonts.primary.getFont(ofSize: 14, weight: .regular)
            }
        }
        
        var timeFont: UIFont {
            switch self {
            case .first: return SLFonts.primary.getFont(ofSize: 30, weight: .bold)
            case .second, .third: return SLFonts.primary.getFont(ofSize: 15, weight: .medium)
            }
        }
        
        var size: CGSize {
            let height = Constants.screenSize.width*100/390
            switch self {
            case .first: return .init(width: Constants.screenSize.width-48-(height*2), height: height)
            case .second, .third: return .init(width: height, height: height)
            }
        }
    }
}
