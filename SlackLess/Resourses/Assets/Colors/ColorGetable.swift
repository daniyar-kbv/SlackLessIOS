//
//  ColorGetable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

protocol ColorGeatble {
    var rawValue: String { get }
    func getColor() -> UIColor?
}

extension ColorGeatble {
    func getColor() -> UIColor? {
        return UIColor(named: rawValue)
    }
}
