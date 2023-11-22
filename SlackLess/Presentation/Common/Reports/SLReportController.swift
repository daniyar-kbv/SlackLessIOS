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
    private var state: State = .broken {
        didSet {
            reload()
        }
    }
    
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
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    
    private func setTimer() {
        timer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshState), userInfo: nil, repeats: true)
    }
    
    private func layoutUI(){
        view.backgroundColor = SLColors.background1.getColor()
        
        [contentView].forEach({ view.addSubview($0) })
        
        contentView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    private func bindViewModel() {
        viewModel.output.reload
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                hostingController.rootView = makeReport(with: viewModel.output.getFilter())
            })
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        reload()
        state = .waiting
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in
            self?.state = .broken
        }
    }
    
    private func reload() {
        switch state {
        case .broken:
            showLoader(overlayColor: SLColors.background1.getColor())
            
            remove(controller: hostingController)
            
            hostingController = makeHostingController(with: viewModel.output.getFilter())
            hostingController.view.backgroundColor = SLColors.background1.getColor()
            hostingController.didLayoutSubviews
                .subscribe(onNext: { [weak self] in
                    self?.refreshState()
                })
                .disposed(by: disposeBag)
            
            add(controller: hostingController, to: contentView)
        case .normal:
            hideLoader(animated: false)
        case .waiting:
            break
        }
    }
    
    @objc private func refreshState() {
        let isBroken = checkIfBroken()
        switch state {
        case .broken:
            guard !isBroken else { break }
            state = .normal
        case .normal:
            guard isBroken else { break }
            state = .broken
        case .waiting:
            break
        }
    }
    
    private func checkIfBroken() -> Bool {
        hostingController.view.containsView(of: "EXPlaceholderView")
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
        case broken
        case normal
        case waiting
    }
}
 
final class SLHostingController: UIHostingController<DeviceActivityReport> {
    let didLayoutSubviews = PublishRelay<Void>()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        didLayoutSubviews.accept(())
    }
}
