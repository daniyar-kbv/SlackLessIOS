//
//  SummarySelectedAppsTableViewCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-10.
//

import Foundation
import UIKit
import SnapKit

final class SummaryOtherAppsTableViewCell: UITableViewCell {
    private(set) var appTimeView: SLAppTimeView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        layoutUI()
    }
    
    private func layoutUI() {
        appTimeView?.removeFromSuperview()
        
        appTimeView = .init(type: .large)
        
        addSubview(appTimeView!)
        appTimeView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

extension SummaryOtherAppsTableViewCell {
    func set(appInfo: AppInfo, ratio: CGFloat, maxTime: Int?) {
        appTimeView?.set(icon: appInfo.image,
                        name: appInfo.name,
                        time: appInfo.time,
                        ratio: ratio,
                        maxTime: maxTime)
    }
}
