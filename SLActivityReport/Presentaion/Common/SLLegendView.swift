//
//  SLLegendView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-12.
//

import Foundation
import UIKit
import SnapKit

final class SLLegendView: UIStackView {
    private let type: `Type`
    
    private lazy var slackedView = LegendView(type: .slacked(sliced: type == .twoColor))
    private lazy var otherAppsView = LegendView(type: .otherApps)
    
    init(type: Type) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [slackedView, otherAppsView].forEach(addArrangedSubview(_:))
        axis = .horizontal
        alignment = .fill
        spacing = 8
    }
}

extension SLLegendView {
    enum `Type` {
        case oneColor
        case twoColor
    }
}

fileprivate final class LegendView: UIStackView {
    let type: `Type`
    
    private(set) lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = type.color
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var halfCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray4.getColor()
        view.transform = view.transform.rotated(by: 45.0/180.0*CGFloat.pi)
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = type.text
        view.textColor = SLColors.label1.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        return view
    }()
    
    init(type: `Type`) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [circleView, titleLabel].forEach(addArrangedSubview(_:))
        axis = .horizontal
        alignment = .center
        spacing = 4
        
        circleView.snp.makeConstraints({
            $0.size.equalTo(8)
        })
        
        switch type {
        case let .slacked(sliced):
            if sliced {
                circleView.addSubview(halfCircleView)
                halfCircleView.snp.makeConstraints({
                    $0.size.equalTo(8)
                    $0.centerX.equalToSuperview().offset(CGFloat.squareRoot(8)())
                    $0.centerY.equalToSuperview().offset(CGFloat.squareRoot(8)())
                })
            }
        default: break
        }
    }
}

extension LegendView {
    enum `Type` {
        case slacked(sliced: Bool)
        case otherApps
        
        var text: String {
            switch self {
            case .slacked: return SLTexts.Summary.ThirdContainer.Legend.firstTitle.localized()
            case .otherApps: return SLTexts.Summary.ThirdContainer.Legend.secondTitle.localized()
            }
        }
        
        var color: UIColor? {
            switch self {
            case .slacked: return SLColors.accent1.getColor()
            case .otherApps: return SLColors.gray5.getColor()
            }
        }
    }
}
