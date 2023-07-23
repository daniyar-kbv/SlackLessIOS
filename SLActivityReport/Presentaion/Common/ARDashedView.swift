//
//  ARDashedLineLayer.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-22.
//

import Foundation
import UIKit

final class ARDashedView: UIView {
    private(set) lazy var dashedLineLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dashedLineLayer.frame = frame
        
        let path = CGMutablePath()
        path.addLines(between: [.init(x: frame.minX,
                                      y: frame.minY),
                                .init(x: frame.maxX,
                                      y: frame.maxY)])
        dashedLineLayer.path = path
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dashedLineLayer.strokeColor = SLColors.gray4.getColor()?.cgColor
        dashedLineLayer.lineWidth = 0.5
        dashedLineLayer.lineDashPattern = [2, 2]
        layer.addSublayer(dashedLineLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
