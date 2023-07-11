//
//  SummaryAppsCollectionViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SummaryAppsCollectionViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var contentView = SummaryAppsCollectionView()
    private let viewModel: SummaryAppsCollectionViewModel
    
    init(viewModel: SummaryAppsCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        contentView.appsCollectionView.dataSource = self
        contentView.appsCollectionView.delegate = self
        contentView.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let currentPage = self?.contentView.pageControl.currentPage else { return }
                self?.contentView.appsCollectionView.scrollToItem(at: .init(item: currentPage*4,
                                                                            section: 0),
                                                                  at: .left,
                                                                  animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SummaryAppsCollectionViewController {
    func getContentView() -> UIView {
        return contentView
    }
}

extension SummaryAppsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.output.getNumberOfItems()
        contentView.pageControl.numberOfPages = (numberOfItems+3)/4
        contentView.pageControl.isHidden = numberOfItems <= 4
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.appsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SummaryAppsCollectionCell.self),
                                                                      for: indexPath) as! SummaryAppsCollectionCell
        cell.set(appInfo: viewModel.output.getAppInfoItem(for: indexPath.item),
                 ratio: viewModel.output.getAppTimeRatio(for: indexPath.item),
                 maxTime: viewModel.output.getMaxTime())
        return cell
    }
}

extension SummaryAppsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width-(16*3))/2, height: ((collectionView.frame.height-12)/2)-2)
    }
}

extension SummaryAppsCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentView.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
