//
//  SummaryCOntroller.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SummaryController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryView()
    private let viewModel: SummaryViewModel

    init(viewModel: SummaryViewModel) {
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
        configNavBar()
        configView()
        bindViewModel()
        bindView()
    }
}

extension SummaryController {
    private func configNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.topItem?.title = SLTexts.Summary.title.localized()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func configView() {
        
    }
    
    private func bindViewModel() {
        viewModel
            .output
            .date
            .bind(to: contentView.dateSwitcherView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .isLastDate
            .subscribe(onNext: { [weak self] in
                self?.contentView.dateSwitcherView.rightButton.isEnabled = !$0
            })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        contentView
            .dateSwitcherView
            .leftButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.input.changeDate(forward: false)
            }
            .disposed(by: disposeBag)
        
        contentView
            .dateSwitcherView
            .rightButton
            .rx
            .tap
            .bind { [weak self] in
                self?.viewModel.input.changeDate(forward: true)
            }
            .disposed(by: disposeBag)
    }
}
