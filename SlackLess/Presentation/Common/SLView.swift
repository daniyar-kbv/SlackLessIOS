//
//  SLView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit

 class SLView: UIView {
    internal lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        super.addSubview(contentView)
        contentView.snp.makeConstraints({
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.right.equalToSuperview().inset(16)
        })
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
}
