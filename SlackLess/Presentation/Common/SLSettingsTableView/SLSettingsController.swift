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
        view.register(SLSettingsCell.self, forCellReuseIdentifier: String(describing: SLSettingsCell.self))
        view.register(SLSettingsHeaderCell.self, forCellReuseIdentifier: String(describing: SLSettingsHeaderCell.self))
        view.register(SLSettingsSpacerCell.self, forCellReuseIdentifier: String(describing: SLSettingsSpacerCell.self))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = SLColors.background1.getColor()
        view.separatorStyle = .none
        view.bounces = false
        view.delaysContentTouches = false
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
    func numberOfSections(in _: UITableView) -> Int {
        viewModel.output.getNumberOfSections()
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.getNumberOfItems(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsHeaderCell.self), for: indexPath) as! SLSettingsHeaderCell
            cell.titleLabel.text = viewModel.output.getTitle(for: indexPath.section)
            return cell
        case tableView.numberOfRows(inSection: indexPath.section) - 1:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsSpacerCell.self), for: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsCell.self), for: indexPath) as! SLSettingsCell

            var position: SLSettingsCell.Position = .middle
            if tableView.numberOfRows(inSection: indexPath.section) == 3 {
                position = .single
            } else if indexPath.row == 1 {
                position = .top
            } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 2 {
                position = .bottom
            }

            cell.set(type: viewModel.output.getItemType(for: indexPath), position: position) { _ in
            }
            return cell
        }
    }
}

extension SLSettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 20
        case tableView.numberOfRows(inSection: indexPath.section) - 1: return 16
        default: return 40
        }
    }

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        return true
    }
}
