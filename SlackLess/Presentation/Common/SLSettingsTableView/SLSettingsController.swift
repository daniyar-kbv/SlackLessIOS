//
//  SLSettingsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation
import UIKit

final class SLSettingsController: UIViewController {
    private let viewModel: SLSettingsViewModel
    
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 40
        view.sectionHeaderHeight = 20
        view.register(SLSettingsCell.self, forCellReuseIdentifier: String(describing: SLSettingsCell.self))
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    init(viewModel: SLSettingsViewModel) {
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
        
        configure()
    }
    
    private func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = SLTexts.Customize.title.localized()
    }
}

extension SLSettingsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.output.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.getNumberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsCell.self), for: indexPath) as! SLSettingsCell
        cell.set(type: viewModel.output.getItemType(for: indexPath))
        return cell
    }
}

extension SLSettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SLSettingsHeaderView()
        headerView.titleLabel.text = viewModel.output.getTitle(for: section)
        return headerView
    }
}
