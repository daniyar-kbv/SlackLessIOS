//
//  CustomizeView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-12-04.
//

import Foundation
import UIKit
import SnapKit

final class CustomizeView: SLBaseView {
    private(set) lazy var settingsView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        [settingsView].forEach(addSubview(_:))
        
        settingsView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
