//
//  ARAppView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import SnapKit
import SwiftUI
import UIKit

final class ARAppView: UIStackView {
    private(set) lazy var appIconView = SLAppIconView()

    private(set) lazy var appNameLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        return view
    }()

    private(set) lazy var timeBarView: UIView = {
        let view = UIView()
        let height: CGFloat = 5
        view.backgroundColor = SLColors.gray3.getColor()
        view.layer.cornerRadius = height / 2
        return view
    }()

    private(set) lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.textColor = SLColors.gray3.getColor()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [appIconView, appNameLabel, timeBarView, timeLabel].forEach(addSubview(_:))

        let appIconSize = 28.0

        appIconView.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
            $0.size.equalTo(appIconSize)
        }

        appIconView.layer.cornerRadius = appIconSize / 5

        appNameLabel.snp.makeConstraints {
            $0.left.equalTo(appIconView.snp.right).offset(12)
            $0.top.equalTo(appIconView)
            $0.right.equalToSuperview()
        }

        timeBarView.snp.makeConstraints {
            $0.left.equalTo(appIconView.snp.right).offset(12)
            $0.bottom.equalTo(appIconView)
            $0.width.equalTo(0)
        }

        timeLabel.snp.makeConstraints {
            $0.left.equalTo(timeBarView.snp.right).offset(4)
            $0.centerY.equalTo(timeBarView)
        }
    }
    
    private func makeTimeText(from time: TimeInterval, with style: DateComponentsFormatter.UnitsStyle) -> String? {
        if time < 60 {
            return "<\(60.formatted(with: style) ?? "1 min")"
        } else {
            return time.formatted(with: style)
        }
    }
}

extension ARAppView {
    func set(app: ARApp, type: Type) {
        layoutUI()
        
        if let bundleId = app.bundleId,
           let appName = app.name {
            appIconView.update(with: bundleId, appName: appName)
        }

        let timeText = makeTimeText(from: app.time, with: type.timeStyle)
        
        appNameLabel.text = app.name
        appNameLabel.sizeToFit()
        timeLabel.text = timeText
        timeLabel.sizeToFit()

        let textWidth = timeText?.width(withConstrainedHeight: timeLabel.font.lineHeight, font: timeLabel.font) ?? 0
        let maxWidth = type.width - textWidth
        let minWidth = maxWidth * 0.1
        let width = minWidth + ((maxWidth - minWidth) * app.ratio)

        timeBarView.snp.remakeConstraints {
            $0.height.equalTo(5)
            $0.left.equalTo(appIconView.snp.right).offset(12)
            $0.bottom.equalTo(appIconView)
            $0.width.equalTo(width)
        }
    }
}

extension ARAppView {
    enum `Type` {
        case small
        case large

        var width: CGFloat {
            switch self {
            case .small: return ((Constants.screenSize.width - (16 * 5)) / 2) - 44
            case .large: return (Constants.screenSize.width - (16 * 4)) - 44
            }
        }

        var timeStyle: DateComponentsFormatter.UnitsStyle {
            switch self {
            case .small: return .abbreviated
            case .large: return .brief
            }
        }
    }
}
