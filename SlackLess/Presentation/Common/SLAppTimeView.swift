//
//  SLAppTimeView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class SLAppTimeView: UIStackView {
    private(set) lazy var appIconView: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.appIcon.getImage()
        view.snp.makeConstraints({
            $0.size.equalTo(28)
        })
        return view
    }()
    
    private(set) lazy var appNameLabel: UIView = {
        let view = UILabel()
        view.text = "SLackLess"
        view.font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    private(set) lazy var timeBarView: UIView = {
        let view = UIView()
        let height: CGFloat = 5
        view.backgroundColor = SLColors.gray3.getColor()
        view.layer.cornerRadius = height/2
        snp.makeConstraints({
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
    
    private(set) lazy var timeStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [timeBarView, timeLabel])
        view.axis = .horizontal
        view.alignment = .leading
        view.spacing = 4
        return view
    }()
    
    private(set) lazy var rightStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [appNameLabel, timeStack])
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [appIconView, rightStack].forEach(addArrangedSubview(_:))
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        spacing = 12
    }
}

extension SLAppTimeView {
    func setAppIcon(_ image: UIImage) {
        appIconView.image = image
    }
    
    func setAppTime(_ seconds: Int) {
        var timeText = ""
        let hours = seconds/60
        
        if hours >= 1 {
            timeText += "\(hours) h \(makeSeecondsString(seconds))"
        } else {
            timeText = makeSeecondsString(seconds)
        }
        
        func makeSeecondsString(_ seconds: Int) -> String{
            return "\(seconds % 60) min"
        }
    }
    
    func setTimeBarLength(_ length: Float) {
        timeBarView.snp.makeConstraints({ [weak self] in
            guard let self = self else { return }
            $0.width.equalTo((timeStack.frame.width - timeLabel.frame.width - timeStack.spacing) * CGFloat(length))
        })
    }
}
