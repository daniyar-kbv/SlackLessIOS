//
//  SummaryOtherAppsTableViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-10.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SummaryOtherAppsTableViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SummaryAppsCollectionViewModel
    var height: Int = 1

    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SummaryOtherAppsTableViewCell.self, forCellReuseIdentifier: String(describing: SummaryOtherAppsTableViewCell.self))
        view.contentInset = .init(top: 6, left: 16, bottom: 6, right: 32)
        view.delegate = self
        view.dataSource = self
        view.allowsSelection = false
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        view.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 0)
        view.isScrollEnabled = false
        view.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return view
    }()

    init(viewModel: SummaryAppsCollectionViewModel) {
        self.viewModel = viewModel

        super.init(nibName: .none, bundle: .none)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.output.appsChanged
            .subscribe(onNext: tableView.reloadData)
            .disposed(by: disposeBag)
    }
}

extension SummaryOtherAppsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        let numberOfItems = viewModel.output.getNumberOfApps()
        tableView.snp.updateConstraints {
            $0.height.equalTo((numberOfItems * 48) + 12)
        }
        return numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SummaryOtherAppsTableViewCell.self), for: indexPath) as! SummaryOtherAppsTableViewCell
        let app = viewModel.output.getApp(for: indexPath.row)
        cell.appTimeView?.set(app: app, type: .large)
        return cell
    }
}

extension SummaryOtherAppsTableViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 48
    }
}
