//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import Foundation
import UIKit
import SnapKit

final class SummaryView: SLBaseView {
    private(set) lazy var dateSwitcherView = SLDateSwitcherView()
    
    private(set) lazy var reportView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [dateSwitcherView, reportView].forEach(addSubview(_:))
        
        dateSwitcherView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        })
        
        reportView.snp.makeConstraints({
            $0.top.equalTo(dateSwitcherView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        })
    }
}
