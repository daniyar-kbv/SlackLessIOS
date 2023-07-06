//
//  SelectPriceController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SelectPriceController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SelectPriceView()
    private let viewModel: SelectPriceViewModel
    
    init(viewModel: SelectPriceViewModel) {
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
                print("button tapped")
                self?.viewModel.input.save(timeLimit: 10800)
            })
            .disposed(by: disposeBag)
    }
}

