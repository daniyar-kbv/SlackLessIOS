//
//  TokensController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-15.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TokensController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: TokensViewModel
    private lazy var contentView = TokensView()
    
    private var didLayoutSubviews = false

    init(viewModel: TokensViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
        
        hidesBottomBarWhenPushed = true
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

        configureView()
        bindView()
        
        viewModel.output.alert
            .subscribe(onNext: { [weak self] alert in
                self?.hideLoader()
                self?.showAlert(title: alert.message(), message: nil, submitTitle: "Ok", completion: {
                    switch alert {
                    case .purchased: self?.viewModel.input.finish()
                    default: break
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }

    private func configureView() {
        contentView.set(title: "Purchase Tokens")
    }

    private func bindView() {
        contentView.tokensTextView.didEndEditing
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.set(tokens: $0)
                if $0.isEmpty {
                    self?.contentView.button.setTitle("Purchase Tokens", for: .normal)
                    self?.contentView.button.isEnabled = false
                } else {
                    self?.contentView.button.setTitle("Purchase \($0) token(s) for $\($0)", for: .normal)
                    self?.contentView.button.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        contentView.button.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showLoader()
                self?.viewModel.input.submit()
            })
            .disposed(by: disposeBag)
    }
}
