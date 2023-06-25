//
//  RequestAuthController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class RequestAuthController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = RequestAuthView()
    private let viewModel: RequestAuthViewModel
    
    init(viewModel: RequestAuthViewModel) {
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
        
        bindView()
    }
    
    private func bindView() {
        contentView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.requestAuthorization()
            })
            .disposed(by: disposeBag)
    }
}
