//
//  SLReportController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-12.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI
import RxSwift
import RxCocoa
import DeviceActivity

final class SLReportController: UIViewController {
    private let viewModel: SLReportViewModel
    private var hostingController: SLHostingController
    
    private let disposeBag = DisposeBag()
    private var timer: Timer?
    private var state: State = .normal
    
    private(set) lazy var contentView = UIView()
    
    init(viewModel: SLReportViewModel) {
        self.viewModel = viewModel
        
        let reportView = DeviceActivityReport(viewModel.output.getType().getContext())
        hostingController = .init(rootView: reportView)
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reloadIfNeeded()
        
        setTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    private func setTimer() {
        timer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
    }
    
    @objc private func reload() {
        reloadIfNeeded()
    }
    
    private func layoutUI(){
        view.backgroundColor = SLColors.background1.getColor()
        
        [contentView].forEach({ view.addSubview($0) })
        
        contentView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        reloadIfNeeded(force: true)
    }
    
    private func bindViewModel() {
        viewModel.output.reload
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                hostingController.rootView = makeReport(with: viewModel.output.getFilter())
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadIfNeeded(force: Bool = false) {
        if getIsBlank(force: force) && state != .blank {
            state = .blank
            showLoader()
            
            remove(controller: hostingController)
            
            hostingController = makeHostingController(with: viewModel.output.getFilter())
            hostingController.view.backgroundColor = SLColors.background1.getColor()
            hostingController.didLayoutSubviews
                .subscribe(onNext: { [weak self] in
                    self?.reloadIfNeeded()
                })
                .disposed(by: disposeBag)
            
            add(controller: hostingController, to: contentView)
        } else if !getIsBlank(force: force) && state != .normal {
            state = .normal
            hideLoader(animated: false)
        }
    }
    
    private func getIsBlank(force: Bool) -> Bool {
        return hostingController.view.containsView(of: "EXPlaceholderView") || force
    }
    
    private func makeReport(with filter: DeviceActivityFilter) -> DeviceActivityReport {
        .init(viewModel.output.getType().getContext(), filter: filter)
    }
    
    private func makeHostingController(with filter: DeviceActivityFilter) -> SLHostingController {
        .init(rootView: makeReport(with: filter))
    }
}

extension SLReportController {
    enum State {
        case normal
        case blank
    }
}
 
final class SLHostingController: UIHostingController<DeviceActivityReport> {
    let didLayoutSubviews = PublishRelay<Void>()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        didLayoutSubviews.accept(())
    }
}
