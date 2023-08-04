//
//  ProgressWeekReportController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class ProgressWeekReportController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = ProgressWeekReportView()
    let viewModel: ProgressWeekReportViewModel
    
    private lazy var chartViewModel: ARChartViewModel = ARChartViewModelImpl(type: .horizontal,
                                                                             items: viewModel.output.days.value)
    
    init(viewModel: ProgressWeekReportViewModel) {
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
        bindViewModel()
    }
    
    private func configureView() {
        let chartController = ARChartController(viewModel: chartViewModel)
        contentView.chartView.addContent(view: chartController.view)
        add(controller: chartController)
    }
    
    private func bindViewModel() {
        viewModel.output.time.subscribe(onNext: { [weak self] in
            self?.contentView.dashboardView.firstContainer.set(time: $0.currentWeekTime?.slacked,
                                                               previousTime: $0.previousWeekTime?.slacked)
            self?.contentView.dashboardView.secondContainer.set(time: $0.currentWeekTime?.total,
                                                               previousTime: $0.previousWeekTime?.total)
            self?.contentView.dashboardView.thirdContainer.set(time: $0.currentWeekTime?.average ?? 0,
                                                               previousTime: $0.previousWeekTime?.average)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.days
            .subscribe(onNext: chartViewModel.input.set(items:))
            .disposed(by: disposeBag)
    }
}

