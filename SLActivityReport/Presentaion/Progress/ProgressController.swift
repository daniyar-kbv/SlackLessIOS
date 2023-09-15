//
//  ProgressController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class ProgressController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = ProgressView()
    let viewModel: ProgressViewModel
    
    private lazy var currentWeekChartViewModel = ARChartViewModelImpl(
        type: .horizontal,
        items: viewModel.output.days.value
    )
    private lazy var lastWeeksChartViewModel = ARChartViewModelImpl(
        type: .vertical,
        items: viewModel.output.lastWeeks.value
    )
    
    init(viewModel: ProgressViewModel) {
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
        let currentWeekChartController = ARChartController(viewModel: currentWeekChartViewModel)
        contentView.firstContentView.addContent(view: currentWeekChartController.view)
        add(controller: currentWeekChartController)
        
        let lastWeeksChartController = ARChartController(viewModel: lastWeeksChartViewModel)
        contentView.secondContentView.addContent(view: lastWeeksChartController.view)
        add(controller: lastWeeksChartController)
    }
    
    private func bindViewModel() {
        viewModel.output.lastWeeks
            .subscribe(onNext: { [weak self] in
                self?.showLoader($0.isEmpty)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.time.subscribe(onNext: { [weak self] in
            let test = $0
            self?.contentView.dashboardView.firstContainer.set(time: $0.currentWeekTime?.slacked,
                                                               previousTime: $0.previousWeekTime?.slacked)
            self?.contentView.dashboardView.secondContainer.set(time: $0.currentWeekTime?.total,
                                                               previousTime: $0.previousWeekTime?.total)
            self?.contentView.dashboardView.thirdContainer.set(time: $0.currentWeekTime?.average ?? 0,
                                                               previousTime: $0.previousWeekTime?.average)
        })
        .disposed(by: disposeBag)
        
        viewModel.output.days
            .subscribe(onNext: currentWeekChartViewModel.input.set(items:))
            .disposed(by: disposeBag)
        
        viewModel.output.lastWeeks
            .subscribe(onNext: lastWeeksChartViewModel.input.set(items:))
            .disposed(by: disposeBag)
    }
    
    private func showLoader(_ show: Bool) {
        contentView.isHidden = show
        show ? showLoader() : hideLoader()
    }
}


