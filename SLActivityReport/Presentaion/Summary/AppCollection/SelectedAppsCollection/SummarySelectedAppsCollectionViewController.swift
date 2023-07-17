//
//  SummarySelectedAppsCollectionViewController.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SummarySelectedAppsCollectionViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private lazy var contentView = SummarySelectedAppsCollectionView()
    private let viewModel: SummaryAppsCollectionViewModel
//    var height: CGFloat = 
    
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

extension SummarySelectedAppsCollectionViewController {
    func getContentView() -> UIView {
        return contentView
    }
}

extension SummarySelectedAppsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.output.getNumberOfApps()
        contentView.pageControl.numberOfPages = (numberOfItems+3)/4
        contentView.pageControl.isHidden = numberOfItems <= 4
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = contentView.appsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SummarySelectedAppsCollectionCell.self),
                                                                      for: indexPath) as! SummarySelectedAppsCollectionCell
        cell.set(app: viewModel.output.getApp(for: indexPath.item))
        return cell
    }
}

extension SummarySelectedAppsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width-(16*3))/2, height: ((collectionView.frame.height-12)/2)-2)
    }
}

extension SummarySelectedAppsCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentView.pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
