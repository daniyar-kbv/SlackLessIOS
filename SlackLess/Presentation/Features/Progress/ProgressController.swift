//
//  ProgressController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit
import SwiftUI
import DeviceActivity

final class ProgressController: UIViewController {
    private lazy var summaryReport = DeviceActivityReport(.init(Constants.ContextName.progress), filter: Constants.DeviceActivityFilters.progress)
    private lazy var innerController = UIHostingController(rootView: summaryReport)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SLColors.background1.getColor()
        
        add(hostingController: innerController, to: view)
    }
}
