//
//  WelcomeScreenController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class WelcomeScreenController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = WelcomeScreenView()
    private let viewModel: WelcomeScreenViewModel

    init(viewModel: WelcomeScreenViewModel) {
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
        configure()
        bindView()
    }
    
    private func configure() {
        setUpTerms(label: &contentView.bottomLabel,
                   accentColor: SLColors.black.getColor(),
                   clickElementName: contentView.mainButton.titleLabel?.text ?? "",
                   twoLined: true)
    }
    
    private func bindView() {
        contentView.mainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.input.close()
            })
            .disposed(by: disposeBag)
    }
}
