//
//  ARChartView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import UIKit
import SnapKit

final class ARChartView: UIView {
    private let type: ARChartType
    
    private(set) lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray4.getColor()
        return view
    }()
    
    private(set) lazy var rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray4.getColor()
        return view
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        switch type {
        case .horizontal: collectionViewLayout.scrollDirection = .horizontal
        case .vertical: collectionViewLayout.scrollDirection = .vertical
        }
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.register(ARChartCollectionBarCell.self, forCellWithReuseIdentifier: String(describing: ARChartCollectionBarCell.self))
        view.register(ARChartCollectionScaleCell.self, forCellWithReuseIdentifier: String(describing: ARChartCollectionScaleCell.self))
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        view.delaysContentTouches = false
        view.isScrollEnabled = false
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) lazy var legendView: ARLegendView = ARLegendView(type: type == .horizontal ? .oneColor : .twoColor)
    
    init(type: ARChartType) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [collectionView, legendView, topLineView, rightLineView].forEach(addSubview(_:))
        
        switch type {
        case .horizontal:
            collectionView.snp.makeConstraints({
                $0.top.horizontalEdges.equalToSuperview()
                $0.height.equalTo(230)
            })
        case .vertical:
            collectionView.snp.makeConstraints({
                $0.top.horizontalEdges.equalToSuperview()
                $0.height.equalTo(180)
            })
        }
        
        legendView.snp.makeConstraints({
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.left.bottom.equalToSuperview()
        })
        
        topLineView.snp.makeConstraints({
            $0.top.equalTo(collectionView)
            $0.horizontalEdges.equalTo(collectionView)
            $0.height.equalTo(0.25)
        })
        
        rightLineView.snp.makeConstraints({
            $0.right.equalTo(collectionView)
            $0.verticalEdges.equalTo(collectionView)
            $0.width.equalTo(0.5)
        })
    }
}
