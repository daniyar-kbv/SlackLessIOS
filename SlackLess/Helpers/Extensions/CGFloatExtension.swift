//
//  CGFloatExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-02-26.
//

import Foundation

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
