//
//  IntroductionView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-10.
//

import Foundation
import UIKit
import SnapKit

final class IntroductionView: SLView {
    private(set) lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionViewLayout.minimumLineSpacing = 32
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.register(IntroductionCollectionCell.self, forCellWithReuseIdentifier: String(describing: IntroductionCollectionCell.self))
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
        return view
    }()
    
    private(set) lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = SLColors.gray4.getColor()
        view.currentPageIndicatorTintColor = SLColors.accent1.getColor()
        view.backgroundStyle = .minimal
        return view
    }()
    
    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
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
        [collectionView, pageControl, button].forEach { addSubview($0) }
        
        button.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        
        pageControl.snp.makeConstraints({
            $0.bottom.equalTo(button.snp.top).offset(-32)
            $0.centerX.equalToSuperview()
        })
        
        collectionView.snp.makeConstraints({
            $0.top.horizontalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(-16)
            $0.bottom.equalTo(pageControl.snp.top).offset(-16)
        })
    }
}
