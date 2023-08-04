//
//  ProgressPastWeeksController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class ProgressPastWeeksController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = ProgressPastWeeksView()
    let viewModel: ProgressPastWeeksViewModel
    
   private lazy var chartViewModel: ARChartViewModel = ARChartViewModelImpl(type: .vertical,
                                                                            items: viewModel.output.weeks.value)
    
    init(viewModel: ProgressPastWeeksViewModel) {
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
        viewModel.output.weeks
            .subscribe(onNext: chartViewModel.input.set(items:))
            .disposed(by: disposeBag)
    }
}
