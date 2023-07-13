//
//  SummarySelectedAppsCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit

final class SummarySelectedAppsCollectionCell: UICollectionViewCell {
    var appTimeView: SLAppTimeView?
    
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
    func set(appInfo: AppInfo, ratio: CGFloat, maxTime: Int?) {
        appTimeView?.set(icon: appInfo.image,
                        name: appInfo.name,
                        time: appInfo.time,
                        ratio: ratio,
                        maxTime: maxTime)
    }
}
