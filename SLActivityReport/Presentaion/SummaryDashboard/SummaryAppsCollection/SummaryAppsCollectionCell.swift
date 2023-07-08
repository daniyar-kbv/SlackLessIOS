//
//  SummaryAppsCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit

final class SummaryAppsCollectionCell: UICollectionViewCell {
    private(set) lazy var appTimeView: SLAppTimeView = {
        let view = SLAppTimeView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI(){
        contentView.addSubview(appTimeView)
        
        appTimeView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
