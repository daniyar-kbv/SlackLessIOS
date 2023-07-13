//
//  SummaryOtherAppsCollectionViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-10.
//

import Foundation
import UIKit
import SnapKit

final class SummaryOtherAppsTableViewController: UIViewController {
    private let viewModel: SummaryAppsCollectionViewModel
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(SummaryOtherAppsTableViewCell.self, forCellReuseIdentifier: String(describing: SummaryOtherAppsTableViewCell.self))
        view.rowHeight = 48
        view.contentInset = .init(top: 6, left: 16, bottom: 8, right: 32)
        view.delegate = self
        view.dataSource = self
        view.allowsSelection = false
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        view.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 0)
        view.isScrollEnabled = false
        view.snp.makeConstraints({
            $0.height.equalTo(1)
        })
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
}

extension SummaryOtherAppsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfItems = viewModel.output.getNumberOfItems()
        tableView.snp.updateConstraints({
            $0.height.equalTo(numberOfItems*Int(tableView.rowHeight))
        })
        return numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SummaryOtherAppsTableViewCell.self), for: indexPath) as! SummaryOtherAppsTableViewCell
        cell.set(appInfo: viewModel.output.getAppInfoItem(for: indexPath.row),
                 ratio: viewModel.output.getAppTimeRatio(for: indexPath.row),
                 maxTime: viewModel.output.getMaxTime())
        return cell
    }
}
