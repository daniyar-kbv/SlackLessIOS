//
//  SLAppTimeView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit
import SnapKit

final class SLAppTimeView: UIStackView {
    private let type: `Type`
    
    private(set) lazy var appIconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .gray
        view.snp.makeConstraints({
            $0.size.equalTo(28)
        })
        return view
    }()
    
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
        view.layer.cornerRadius = height/2
        view.snp.makeConstraints({
            $0.height.equalTo(height)
        })
        return view
    }()
    
    private(set) lazy var timeLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.textColor = SLColors.gray3.getColor()
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
        [appIconView, appNameLabel, timeBarView, timeLabel].forEach(addSubview(_:))
        
        appIconView.snp.makeConstraints({
            $0.left.centerY.equalToSuperview()
        })
        
        appNameLabel.snp.makeConstraints({
            $0.left.equalTo(appIconView.snp.right).offset(12)
            $0.top.equalTo(appIconView)
            $0.right.equalToSuperview()
        })
        
        timeBarView.snp.makeConstraints({
            $0.left.equalTo(appIconView.snp.right).offset(12)
            $0.bottom.equalTo(appIconView)
        })
        
        timeLabel.snp.makeConstraints({
            $0.left.equalTo(timeBarView.snp.right).offset(4)
            $0.centerY.equalTo(timeBarView)
            $0.right.equalToSuperview()
        })
    }
}

extension SLAppTimeView {
    func set(icon: UIImage?, name: String, time: Int, ratio: CGFloat, maxTime: Int?) {
        appIconView.image = icon
        appNameLabel.text = name
        appNameLabel.sizeToFit()
        timeLabel.text = makeTimeString(from: time)
        timeLabel.sizeToFit()
        
        if let maxTime = maxTime {
            let textWidth = makeTimeString(from: maxTime).width(withConstrainedHeight: timeLabel.font.lineHeight, font: timeLabel.font)
            let maxWidth = type.width-textWidth
            let minWidth = maxWidth*0.1
            let width = minWidth + ((maxWidth-minWidth)*ratio)
            
            timeBarView.snp.makeConstraints({
                $0.width.equalTo(width)
            })
        }
        
        func makeTimeString(from time: Int) -> String {
            var timeText = ""
            let hours = time/3600
            if hours >= 1 {
                timeText += "\(hours) h \(makeSecondsString(time))"
            } else {
                timeText = makeSecondsString(time)
            }
            return timeText
        }
        
        func makeSecondsString(_ seconds: Int) -> String{
            return "\((seconds%3600)/60) min"
        }
    }
}

extension SLAppTimeView {
    enum `Type` {
        case small
        case large
        
        var width: CGFloat {
            switch self {
            case .small: return ((Constants.screenSize.width-(16*5))/2)-44
            case .large: return (Constants.screenSize.width-(16*4))-44
            }
        }
    }
}
