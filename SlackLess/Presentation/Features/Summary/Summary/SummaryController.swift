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
    private lazy var summaryInnerController = UIHostingController(rootView: summaryReport)
    
    override func loadView() {
        super.loadView()
        
        add(hostingController: summaryInnerController, to: view)
    }
}

