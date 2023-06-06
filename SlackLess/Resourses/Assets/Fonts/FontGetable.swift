//
//  FontGetable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

protocol FontGetable {
    var rawValue: String { get }
    func getFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont
}

extension FontGetable {
    func getFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: ofSize, weight: weight)
    }
}
