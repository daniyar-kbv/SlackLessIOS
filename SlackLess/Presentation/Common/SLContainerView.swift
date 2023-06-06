//
//  SLContainerView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class SLContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = SLColors.backgroundElevated.getColor()
        layer.cornerRadius = 8
    }
}

extension SLContainerView {
    func setContent(view: UIView) {
        addSubview(view)
        view.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        })
    }
    
    func setBackGround(color: UIColor?) {
        backgroundColor = color
    }
}
