//
//  SummarySelectedAppsCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit

final class SummarySelectedAppsCollectionCell: UICollectionViewCell {
    var appTimeView: SLAppView?
    
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
    }
    
    private func layoutUI(){
        appTimeView?.removeFromSuperview()
        
        appTimeView = .init(type: .small)
        
        contentView.addSubview(appTimeView!)
        
        appTimeView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

extension SummarySelectedAppsCollectionCell {
    func set(app: ActivityReportApp) {
        appTimeView?.set(app: app)
    }
}
