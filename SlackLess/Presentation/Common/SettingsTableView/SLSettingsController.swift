//
//  SLSettingsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SLSettingsController: UIViewController {
    private let viewModel: SLSettingsViewModel

    private let disposeBag = DisposeBag()

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
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        switch viewModel.output.getType() {
        case .full: break
        case .setUp, .display:
            var height = 0.0
            for section in 0 ..< viewModel.output.getNumberOfSections() {
                for row in 0 ..< viewModel.output.getNumberOfItems(in: section) {
                    height += tableView(tableView, heightForRowAt: .init(row: row, section: section))
                }
            }
            
            tableView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
    }

    private func configure() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.title = SLTexts.Customize.title.localized()

        switch viewModel.output.getType() {
        case .full: break
        case .setUp, .display:
            tableView.snp.makeConstraints {
                $0.height.equalTo(1)
            }
        }
    }

    private func bindViewModel() {
        viewModel.output.errorOccured.subscribe(onNext: { [weak self] in
            self?.showError($0) {
                self?.tableView.reloadData()
            }
        })
        .disposed(by: disposeBag)
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
        switch (viewModel.output.getType(), indexPath.row) {
        case (.full, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsHeaderCell.self), for: indexPath) as! SLSettingsHeaderCell
            cell.titleLabel.text = viewModel.output.getTitle(for: indexPath.section)
            return cell
        case (.full, tableView.numberOfRows(inSection: indexPath.section) - 1):
            return tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsSpacerCell.self), for: indexPath)
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SLSettingsCell.self), for: indexPath) as! SLSettingsCell
            cell.parentConroller = self

            var position: SLSettingsCell.Position = .middle
            switch (viewModel.output.getType(), indexPath.row) {
            case (.full, 1):
                switch tableView.numberOfRows(inSection: indexPath.section) {
                case 3: position = .single
                default: position = .top
                }
                guard tableView.numberOfRows(inSection: indexPath.section) > 3 else { break }
                position = .top
            case (.full, tableView.numberOfRows(inSection: indexPath.section) - 2):
                position = .bottom
            case (.setUp, 0), (.display, 0):
                switch tableView.numberOfRows(inSection: indexPath.section) {
                case 1: position = .single
                default: position = .top
                }
            case (.setUp, tableView.numberOfRows(inSection: indexPath.section) - 1),
                (.display, tableView.numberOfRows(inSection: indexPath.section) - 1):
                position = .bottom
            default:
                break
            }

            cell.set(type: viewModel.output.getItemType(for: indexPath), position: position) { [weak self] in
                switch $0 {
                case let .appsSelection(selection):
                    self?.viewModel.input.set(appSelection: selection)
                case let .time(limit):
                    self?.viewModel.input.set(timeLimit: limit)
                case let .price(price):
                    self?.viewModel.input.set(unlockPrice: price)
                }
            }

            cell.isEnabled = viewModel.output.canChangeSettings || !viewModel.output.isSettings(section: indexPath.section)

            return cell
        }
    }
}

extension SLSettingsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (viewModel.output.getType(), indexPath.row) {
        case (.full, 0): return 20
        case (.full, tableView.numberOfRows(inSection: indexPath.section) - 1): return 16
        default: return 40
        }
    }

    func tableView(_: UITableView, shouldHighlightRowAt _: IndexPath) -> Bool {
        return true
    }
}
