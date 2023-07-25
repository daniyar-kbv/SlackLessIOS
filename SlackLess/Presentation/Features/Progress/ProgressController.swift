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
import SnapKit

final class ProgressController: UIViewController {
    private lazy var summaryReport = DeviceActivityReport(.init(Constants.ContextName.progress), filter: Constants.DeviceActivityFilters.summary)
    private lazy var innerController = UIHostingController(rootView: summaryReport)

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
