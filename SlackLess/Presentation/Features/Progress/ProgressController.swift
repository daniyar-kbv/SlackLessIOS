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
import RxSwift
import RxCocoa

final class ProgressController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = ProgressView()
    private let viewModel: ProgressViewModel
    
//    TODO: try setting sizingOptions
    
    private lazy var weekController = UIHostingController(rootView: makeWeekReport(filter: viewModel.output.weekFilter.value))
    private lazy var pastWeeksController = UIHostingController(rootView: DeviceActivityReport(SLDeviceActivityReportType.pastWeeks.getContext(),
                                                                                              filter: viewModel.output.pastWeeksFilter.value))
    
    init(viewModel: ProgressViewModel) {
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
        contentView.set(title: SLTexts.Progress.title.localized())
        
        add(controller: weekController,
            to: contentView.weekReportView)
        weekController.view.backgroundColor = SLColors.background1.getColor()
        
        add(controller: pastWeeksController,
            to: contentView.pastWeeksReportView)
        pastWeeksController.view.backgroundColor = SLColors.background1.getColor()
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
        viewModel.output.weekFilter.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            weekController.rootView = makeWeekReport(filter: $0)
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
    
    private func makeWeekReport(filter: DeviceActivityFilter) -> DeviceActivityReport {
        .init(SLDeviceActivityReportType.week.getContext(),
              filter: filter)
    }
}
