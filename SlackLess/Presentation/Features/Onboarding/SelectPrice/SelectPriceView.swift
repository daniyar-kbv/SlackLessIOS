//
//  SelectPrice.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import Foundation
import UIKit
import SnapKit

final class SelectPriceView: SLView {
    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .contrastBackground, size: .large)
        view.setTitle("Set 3h Limit", for: .normal)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = SLColors.background1.getColor()
        
        [button].forEach({ addSubview($0) })
        
        button.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview().priority(.high)
        })
    }
}
