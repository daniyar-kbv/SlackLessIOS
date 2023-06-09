//
//  UIImage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-08.
//

import Foundation
import UIKit

extension UIImage {
    func withAlpha(_ alpha: CGFloat) -> UIImage? {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
    }
}
