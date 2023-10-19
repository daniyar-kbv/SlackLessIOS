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
    
    init(strokeColor: CGColor?,
         lineWidth: CGFloat,
         lineDashPattern: [NSNumber]?) {
        super.init(frame: .zero)
        
        dashedLineLayer.strokeColor = strokeColor
        dashedLineLayer.lineWidth = lineWidth
        dashedLineLayer.lineDashPattern = lineDashPattern
        layer.addSublayer(dashedLineLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

extension ARDashedView {
    enum Side {
        case top
        case bottom
        case left
        case right
    }
}
