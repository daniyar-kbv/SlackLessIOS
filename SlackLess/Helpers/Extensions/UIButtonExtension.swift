//
//  UIButton.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

extension UIButton {
    func setBackgroundColor(color: UIColor?, forState: UIControl.State) {
        clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext(),
           let color = color
        {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setBackgroundImage(colorImage, for: forState)
        }
    }
}
