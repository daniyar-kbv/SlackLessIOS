//
//  SummaryInnerController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import Foundation
import UIKit
import SwiftUI
import DeviceActivity

final class SummaryController: UIViewController {
    private lazy var summaryReport = DeviceActivityReport(.init(Constants.ContextName.summary), filter: Constants.DeviceActivityFilters.summary)
    private lazy var innerController = UIHostingController(rootView: summaryReport)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SLColors.background1.getColor()
        
        add(hostingController: innerController, to: view)
    }
}
