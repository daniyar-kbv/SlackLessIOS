//
//  SelectAppsContainerView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-25.
//

import Foundation
import UIKit

final class SelectAppsView: SLView {
    private(set) lazy var buttonView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [buttonView].forEach({ addSubview($0) })
        
        buttonView.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview()
//            Tech debt: Refactor
            $0.height.equalTo(60)
        })
    }
}

