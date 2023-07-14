//
//  SelectApps.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import FamilyControls
import SwiftUI
import SnapKit

final class SelectAppsController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SelectAppsView()
    private let viewModel: SelectAppsViewModel
    
    private lazy var buttonContainerView = SelectAppsButtonContainerView(onSelect: appsSelected(_:))
    private lazy var hostingController = UIHostingController(rootView: buttonContainerView)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
    }
    
    private func configView() {
        add(hostingController: hostingController,
            to: contentView.buttonView)
    }
    
    private func appsSelected(_ selection: FamilyActivitySelection) {
        viewModel.input.set(selectedApps: selection)
    }
}

