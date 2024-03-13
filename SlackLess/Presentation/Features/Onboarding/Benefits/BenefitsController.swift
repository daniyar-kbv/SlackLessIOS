//
//  BenefitsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BenefitsController: UIViewController {
    private let viewModel: BenefitsViewModel
    private lazy var contentView = BenefitsView()
    private let disposeBag = DisposeBag()
    
    init(viewModel: BenefitsViewModel) {
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
        
        configure()
        bindView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateTableViewHeight()
    }
    
    private func configure() {
        contentView.tableView.dataSource = self
    }
    
    private func bindView() {
        contentView.button.rx.tap
            .subscribe(onNext: viewModel.input.continueTapped)
            .disposed(by: disposeBag)
    }
    
    private func updateTableViewHeight() {
        contentView.tableView.snp.updateConstraints({
            $0.height.equalTo(getTableViewHeight(in: contentView.tableView))
        })
    }
}

extension BenefitsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.output.getNumberOfBenefits()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0..<viewModel.output.getNumberOfBenefits()-1: return 2
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BenefitsTableCell.self), for: indexPath) as! BenefitsTableCell
            cell.set(benefitType: viewModel.output.getBenefitType(at: indexPath.section))
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: SLTableViewSpacerCell.reuseIdentifier, for: indexPath)
        }
    }
}

extension BenefitsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 48
        default: return 40
        }
    }
}
