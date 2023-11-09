//
//  UIView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-24.
//

import Foundation
import SnapKit
import UIKit

// TODO: refactor extensions to protocols

extension UIView {
    func getAllSubviews() -> [UIView] {
        subviews + subviews.flatMap { $0.getAllSubviews() }
    }
    
    func getAllSubviewNames() -> [String] {
        getAllSubviews().map({ $0.getClassName() })
    }

    func containsView(of typeString: String) -> Bool {
        getAllSubviews().contains(where: { $0.getClassName() == typeString })
    }
    
    func getFirstSubview(of typeString: String) -> UIView? {
        getAllSubviews().first(where: { $0.getClassName() == typeString })
    }
    
    func getClassName() -> String {
        String(describing: type(of: self))
    }
}
