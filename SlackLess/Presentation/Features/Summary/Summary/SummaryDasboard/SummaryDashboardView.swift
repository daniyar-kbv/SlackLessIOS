//
//  SummaryDashboardView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import Foundation
import UIKit
import SnapKit

final class SummaryDashboardView: UIView {
    private var startPoint = CGFloat(-Double.pi)
    private var endPoint = CGFloat(0)
    
    private(set) lazy var circleLayer: CAShapeLayer = {
        let view = CAShapeLayer()
        view.fillColor = UIColor.clear.cgColor
        view.lineCap = .round
        view.lineWidth = 32
        view.strokeEnd = 1.0
        view.strokeColor = SLColors.background1.getColor()?.cgColor
        return view
    }()
    
    private(set) lazy var progressLayer: CAShapeLayer = {
        let view = CAShapeLayer()
        view.fillColor = UIColor.clear.cgColor
        view.lineCap = .round
        view.lineWidth = 32
        view.strokeEnd = 0
        view.strokeColor = SLColors.accent2.getColor()?.cgColor
        return view
    }()
    
    private(set) lazy var topTitlelLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .bold)
        view.textColor = SLColors.white.getColor()
        view.text = SLTexts.Summary.FirstContainer.title.localized()
        return view
    }()
    
    private(set) lazy var middleTitlelLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 64, weight: .bold)
        view.textColor = SLColors.white.getColor()
        view.text = "1:20"
        return view
    }()
    
    private(set) lazy var bottomTitlelLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 13, weight: .bold)
        view.textColor = SLColors.white.getColor()
        view.text = SLTexts.Summary.FirstContainer.subtitle.localized("3h")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        backgroundColor = SLColors.accent1.getColor()
        clipsToBounds = true
        
        let height = (Constants.screenSize.width-64)/2+16
        
        snp.makeConstraints({
            $0.height.equalTo(height)
        })
        
        [middleTitlelLabel, topTitlelLabel, bottomTitlelLabel].forEach(addSubview(_:))
        middleTitlelLabel.snp.makeConstraints({ [weak self] in
            guard let self = self else { return }
            $0.centerY.equalTo(self.snp.bottom).inset((height-48)/2-8)
            $0.centerX.equalToSuperview()
        })
        
        topTitlelLabel.snp.makeConstraints({
            $0.bottom.equalTo(middleTitlelLabel.snp.top).offset(8)
            $0.centerX.equalTo(middleTitlelLabel)
        })
        
        bottomTitlelLabel.snp.makeConstraints({
            $0.top.equalTo(middleTitlelLabel.snp.bottom).offset(-8)
            $0.centerX.equalTo(middleTitlelLabel)
        })
        
        [circleLayer, progressLayer].forEach(layer.addSublayer(_:))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height), radius: (frame.width-64)/2, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        progressAnimation()
    }
    
    func progressAnimation() {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.beginTime = CACurrentMediaTime() + 0.5
        circularProgressAnimation.duration = 0.75
        circularProgressAnimation.toValue = 0.4
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        circularProgressAnimation.timingFunction = .init(name: .easeInEaseOut)
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
