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
    private var hostingController: SLHostingController?
    
    private let disposeBag = DisposeBag()
    private var refreshStateTimer: Timer?
    private var resetReportTimer: Timer?
    private var isFirstLoad = true
    private var isBackground = true
    private var state: State = .broken {
        didSet {
            reload()
        }
    }
    
    private(set) lazy var contentView = UIView()
    
    init(viewModel: SLReportViewModel) {
        self.viewModel = viewModel
        
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
        
        isBackground = false
        
        if isFirstLoad {
            isFirstLoad = false
            configure()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isBackground = true
    }
    
    private func startTimers() {
        refreshStateTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshState), userInfo: nil, repeats: true)
        resetReportTimer = .scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            hostingController?.rootView = makeReport(with: viewModel.output.getFilter())
        }
    }
    
    private func stopTimers() {
        refreshStateTimer?.invalidate()
        resetReportTimer?.invalidate()
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
                getHostingController().rootView = makeReport(with: viewModel.output.getFilter())
            })
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        reload()
        startTimers()
        
        switch viewModel.output.getType() {
        case .summary:
            state = .waiting
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
                self?.state = .broken
            }
        default:
            break
        }
    }
    
    private func reload() {
        print("Report \"\(viewModel.output.getType())\": \(state) state")
        switch state {
        case .broken:
            showLoader(overlayColor: SLColors.background1.getColor())
            
            remove(controller: getHostingController())
            
            let hostingController = getHostingController(new: true)
            
            add(controller: hostingController, to: contentView)
        case .normal:
            hideLoader(animated: false)
        case .waiting:
            break
        }
    }
    
    @objc private func refreshState() {
        guard !isBackground else { return }
        
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
        getHostingController().view.containsView(of: "EXPlaceholderView")
    }
    
    private func makeReport(with filter: DeviceActivityFilter) -> DeviceActivityReport {
        .init(viewModel.output.getType().getContext(), filter: filter)
    }
    
    private func getHostingController(new: Bool = false) -> SLHostingController {
        if hostingController == nil || new {
            hostingController = .init(rootView: makeReport(with: viewModel.output.getFilter()))
            hostingController?.view.backgroundColor = SLColors.background1.getColor()
            hostingController?.didLayoutSubviews
                .subscribe(onNext: { [weak self] in
                    self?.refreshState()
                })
                .disposed(by: disposeBag)
        }
        return hostingController!
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
