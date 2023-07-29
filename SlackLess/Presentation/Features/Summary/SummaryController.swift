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
import SnapKit

final class SummaryController: UIViewController {
    private lazy var report = DeviceActivityReport(.init(Constants.ContextName.summary), filter: Constants.DeviceActivityFilters.summary)
    private lazy var innerController = UIHostingController(rootView: report)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SLColors.background1.getColor()
        
        add(controller: innerController,
            to: view,
            with: { [weak self] in
            guard let self = self else { return }
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.horizontalEdges.equalToSuperview()
        })
    }
}
