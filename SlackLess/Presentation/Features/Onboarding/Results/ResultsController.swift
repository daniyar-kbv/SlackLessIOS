//
//  ResultsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ResultsController: UIViewController {
    private let viewModel: ResultsViewModel
    private lazy var contentView = ResultsView()
    private let disposeBag = DisposeBag()
    
    init(viewModel: ResultsViewModel) {
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
        
        bindViewModel()
        bindView()
    }
    
    private func bindViewModel() {
        viewModel.output.state.subscribe(onNext: contentView.set(state:))
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        contentView.button.rx.tap
            .subscribe(onNext: viewModel.input.buttonTapped)
            .disposed(by: disposeBag)
    }
}
