//
//  FontGetable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit
import SwiftUI

//  TODO: Refactor to use styles

protocol FontGetable {
    var rawValue: String { get }
    func getFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont
    func getSwiftUIFont(ofSize: CGFloat, weight: UIFont.Weight) -> Font
}

extension FontGetable {
    func getFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: ofSize, weight: weight)
    }
    
    func getSwiftUIFont(ofSize: CGFloat, weight: UIFont.Weight) -> Font {
        Font(getFont(ofSize: ofSize, weight: weight))
    }
}
