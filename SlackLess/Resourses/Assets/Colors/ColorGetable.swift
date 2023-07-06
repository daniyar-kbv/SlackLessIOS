//
//  ColorGetable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit
import SwiftUI

protocol ColorGeatble {
    var rawValue: String { get }
    func getColor() -> UIColor?
    func getSwiftUIColor() -> Color
}

extension ColorGeatble {
    func getColor() -> UIColor? {
        return UIColor(named: rawValue)
    }
    
    func getSwiftUIColor() -> Color {
        Color(getColor() ?? .clear)
    }
}
