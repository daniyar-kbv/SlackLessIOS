//
//  SummarySelectedAppsCollectionViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import ManagedSettings
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import UIKit

// TODO: show all selected apps

final class SummarySelectedAppsCollectionViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let contentView = SummarySelectedAppsCollectionView()
    private let viewModel: SummaryAppsCollectionViewModel

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

        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentView.appsCollectionView.reloadData()
    }

    private func configure() {
        contentView.appsCollectionView.dataSource = self
        contentView.appsCollectionView.delegate = self
        contentView.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let currentPage = self?.contentView.pageControl.currentPage else { return }
                self?.contentView.appsCollectionView.scrollToItem(at: .init(item: 0,
                                                                            section: currentPage),
                                                                  at: .left,
                                                                  animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.output.appsChanged
            .subscribe(onNext: contentView.appsCollectionView.reloadData)
            .disposed(by: disposeBag)
    }
}

extension SummarySelectedAppsCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        let numberOfApps = viewModel.output.getNumberOfApps()
        let numberOfPages = (numberOfApps + 3) / 4
        contentView.pageControl.numberOfPages = numberOfPages
        contentView.pageControl.isHidden = numberOfPages < 2
        contentView.appsCollectionView.snp.updateConstraints {
            $0.height.equalTo(numberOfApps > 1 ? 88 : 38)
        }
        return numberOfPages
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfApps = viewModel.output.getNumberOfApps()
        let numberOfPages = (numberOfApps + 3) / 4
        if section + 1 < numberOfPages {
            return 4
        } else {
            return numberOfApps - (section * 4)
        }
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.appsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SummarySelectedAppsCollectionCell.self),
                                                                      for: indexPath) as! SummarySelectedAppsCollectionCell
        let app = viewModel.output.getApp(for: (indexPath.section * 4) + indexPath.item)
        cell.appTimeView?.set(app: app, type: viewModel.output.getNumberOfApps() > 2 ? .small : .large)
        return cell
    }
}

extension SummarySelectedAppsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = viewModel.output.getNumberOfApps() - (indexPath.section * 4) > 2 ? (collectionView.frame.width - 48) / 2 : collectionView.frame.width - 32
        let height = viewModel.output.getNumberOfApps() - (indexPath.section * 4) > 1 ? ((collectionView.frame.height - 12) / 2) - 2 : collectionView.frame.height
        guard height >= 0, width >= 0 else { return .init(width: 0, height: 0) }
        return .init(width: width, height: height)
    }
}

extension SummarySelectedAppsCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentView.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
