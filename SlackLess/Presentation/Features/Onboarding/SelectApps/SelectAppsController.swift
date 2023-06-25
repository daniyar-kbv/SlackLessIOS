//
//  SelectApps.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit

final class SelectAppsController: UIViewController {
    private let contentView = SelectAppsView()
    private let viewModel: SelectAppsViewModel
    
    init(viewModel: SelectAppsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
}

