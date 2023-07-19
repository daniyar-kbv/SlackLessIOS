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
    func add(hostingController: UIHostingController<some View>, to view: UIView, with contstraints: ((_ make: ConstraintMaker) -> Void)?)
}

extension UIViewController: UIHostingControllerConfigurable {
    func add(hostingController: UIHostingController<some View>, to view: UIView, with contstraints: ((_ make: ConstraintMaker) -> Void)? = nil) {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        hostingController.didMove(toParent: self)
    }
}
