//
//  File.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class SummaryAppsCollectionView: UIView {
    private(set) lazy var appsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionViewLayout.minimumLineSpacing = 24
        collectionViewLayout.minimumInteritemSpacing = 16
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.register(SummaryAppsCollectionCell.self, forCellWithReuseIdentifier: String(describing: SummaryAppsCollectionCell.self))
        view.delaysContentTouches = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
    }()
    
    private(set) lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.hidesForSinglePage = true
        view.pageIndicatorTintColor = SLColors.gray4.getColor()
        view.currentPageIndicatorTintColor = SLColors.accent1.getColor()
        view.backgroundStyle = .minimal
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [appsCollectionView, pageControl].forEach(addSubview(_:))
        
        appsCollectionView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(80)
        })
        
        pageControl.snp.makeConstraints({
            $0.top.equalTo(appsCollectionView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().offset(-8)
            $0.centerX.equalToSuperview()
        })
    }
}
