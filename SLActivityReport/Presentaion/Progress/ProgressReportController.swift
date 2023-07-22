//
//  ProgressReportController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class ProgressReportController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = ProgressReportView()
//    private let hostingController = UIHostingController(rootView: ChartView())
    let viewModel: ProgressReportViewModel
    
    init(viewModel: ProgressReportViewModel) {
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
        
        
        configureView()
        bindView()
        bindViewModel()
    }
    
    private func configureView() {
//        add(hostingController: hostingController, to: contentView.currentWeekChartView)
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
        viewModel.output.date
            .bind(to: contentView.dateSwitcherView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.time.subscribe(onNext: { [weak self] in
            self?.contentView.dashboardView.firstContainer.set(time: $0.currentWeekTime.slacked,
                                                               previousTime: $0.previousWeekTime?.slacked)
            self?.contentView.dashboardView.secondContainer.set(time: $0.currentWeekTime.total,
                                                               previousTime: $0.previousWeekTime?.total)
            self?.contentView.dashboardView.thirdContainer.set(time: $0.currentWeekTime.average ?? 0,
                                                               previousTime: $0.previousWeekTime?.average)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.isntFirstDate.bind(to: contentView.dateSwitcherView.leftButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.output.isntLastDate.bind(to: contentView.dateSwitcherView.rightButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

