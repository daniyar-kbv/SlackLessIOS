//
//  SummarySelectedAppsTableViewCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-10.
//

import Foundation
import UIKit
import SnapKit

// Tech debt: refactor cells

final class SummaryOtherAppsTableViewCell: UITableViewCell {
    private(set) var appView: ARAppView?
    
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
        appView?.removeFromSuperview()
        
        appView = .init()
        
        addSubview(appView!)
        appView?.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
