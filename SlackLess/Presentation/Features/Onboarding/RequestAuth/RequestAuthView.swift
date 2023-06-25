//
//  RequestAuthView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import UIKit

final class RequestAuthView: SLView {
    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .contrastBackground, size: .large)
        view.setTitle("Request Authorization", for: .normal)
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
        [button].forEach({ addSubview($0) })
        
        button.snp.makeConstraints({
            $0.bottom.left.right.equalToSuperview().priority(.high)
        })
    }
}
