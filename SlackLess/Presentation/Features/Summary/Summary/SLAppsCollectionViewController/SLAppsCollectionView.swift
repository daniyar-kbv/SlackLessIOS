//
//  File.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class SLAppsCollectionView: UIView {
    private(set) lazy var appsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = .init(top: 16, left: 8, bottom: 8, right: 16)
        collectionViewLayout.minimumLineSpacing = 24
        collectionViewLayout.minimumInteritemSpacing = 16
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.register(SLAppsCollectionCell.self, forCellWithReuseIdentifier: String(describing: SLAppsCollectionCell.self))
        view.delaysContentTouches = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.isPagingEnabled = true
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
    }
}
