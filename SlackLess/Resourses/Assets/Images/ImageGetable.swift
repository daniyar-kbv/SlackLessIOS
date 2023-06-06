//
//  ImageGetable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

protocol ImageGetable {
    var rawValue: String { get }
    func getImage() -> UIImage?
}

extension ImageGetable {
    func getImage() -> UIImage? {
        return UIImage(named: rawValue)
    }
}
