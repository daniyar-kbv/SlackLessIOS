//
//  SLContainerView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit
import SnapKit

class SLContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func layoutUI() {
        backgroundColor = SLColors.backgroundElevated.getColor()
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setContentView(_ view: UIView) {
        addSubview(view)
        view.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func addContent(view: UIView) {
        addSubview(view)
        view.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview().inset(8)
        })
    }
}
