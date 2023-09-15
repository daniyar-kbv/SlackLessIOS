//
//  UIView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-24.
//

import Foundation
import UIKit
import SnapKit

// TODO: refactor extensions to protocols

extension UIView {
    func getAllSubviews() -> [UIView] {
        subviews + subviews.flatMap({ $0.getAllSubviews() })
    }
    
    func containsView(of typeString: String) -> Bool {
        getAllSubviews().contains(where: { String(describing: type(of: $0)) == typeString })
    }
}
