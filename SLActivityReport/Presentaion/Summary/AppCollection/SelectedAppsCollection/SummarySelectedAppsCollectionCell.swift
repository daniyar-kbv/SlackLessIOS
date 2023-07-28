//
//  SummarySelectedAppsCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit
import SnapKit

final class SummarySelectedAppsCollectionCell: UICollectionViewCell {
    private(set) var appTimeView: ARAppView?

    var onReuse: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        layoutUI()
        onReuse?()
    }
    
    private func layoutUI(){
        appTimeView?.removeFromSuperview()
        
        appTimeView = .init()
        
        contentView.addSubview(appTimeView!)
        
        appTimeView?.snp.makeConstraints({
            $0.top.equalToSuperview().offset(4.5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        })
    }
}
