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
    private var hostingController: UIHostingController<DeviceActivityReport>
    
    private let disposeBag = DisposeBag()
    
    private(set) lazy var testButton: UIButton = {
        let view = UIButton()
        view.setTitle("Test", for: .normal)
        view.backgroundColor = .systemBlue
        view.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                print(hostingController.view.getAllSubviewNames())
            })
            .disposed(by: disposeBag)
        return view
    }()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.reloadIfNeeded()
            
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.reloadIfNeeded()
        }
    }
    
    private func layoutUI(){
        view.backgroundColor = SLColors.background1.getColor()
        
        [testButton, contentView].forEach({ view.addSubview($0) })
        testButton.snp.makeConstraints({
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        })
        
        contentView.snp.makeConstraints({
            $0.top.equalTo(testButton.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
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
        guard hostingController.view.containsView(of: "EXPlaceholderView")
        || force else { return }
        remove(controller: hostingController)
        hostingController = makeHostingController(with: viewModel.output.getFilter())
        hostingController.view.backgroundColor = SLColors.background1.getColor()
        add(controller: hostingController, to: contentView)
    }
    
    private func makeReport(with filter: DeviceActivityFilter) -> DeviceActivityReport {
        .init(viewModel.output.getType().getContext(), filter: filter)
    }
    
    private func makeHostingController(with filter: DeviceActivityFilter) -> UIHostingController<DeviceActivityReport> {
        .init(rootView: makeReport(with: filter))
    }
}
