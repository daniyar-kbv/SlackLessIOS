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
import RxSwift
import RxCocoa

final class SummaryController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummaryView()
    private let viewModel: SummaryViewModel
    
    private lazy var innerController = UIHostingController(rootView: makeReport(filter: viewModel.output.filter.value))
    
    init(viewModel: SummaryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configView()
        bindView()
        bindViewModel()
    }
    
    private func configView() {
        contentView.set(title: SLTexts.Summary.title.localized())
        
        add(controller: innerController,
            to: contentView.reportView)
        
        innerController.view.backgroundColor = SLColors.background1.getColor()
    }
    
    private func bindView() {
        contentView.dateSwitcherView.leftButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: false)
            }
            .disposed(by: disposeBag)
        
        contentView.dateSwitcherView.rightButton.rx.tap.bind { [weak self] in
                self?.viewModel.input.changeDate(forward: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.output.filter.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            innerController.rootView = makeReport(filter: $0)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.date
            .bind(to: contentView.dateSwitcherView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isntFirstDate.bind(to: contentView.dateSwitcherView.leftButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.isntLastDate.bind(to: contentView.dateSwitcherView.rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func makeReport(filter: DeviceActivityFilter) -> DeviceActivityReport {
        .init(.init(Constants.ContextName.summary),
              filter: filter)
    }
}
