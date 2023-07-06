//
//  UIHostingControllerConfigurable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-03.
//

import Foundation
import SwiftUI
import UIKit
import SnapKit

protocol UIHostingControllerConfigurable {
    func add(hostingController: UIHostingController<some View>, to view: UIView)
}

extension UIViewController: UIHostingControllerConfigurable {
    func add(hostingController: UIHostingController<some View>, to view: UIView) {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        hostingController.didMove(toParent: self)
    }
}
