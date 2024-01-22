//
//  TokensView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-15.
//

import Foundation
import SnapKit
import UIKit

final class TokensView: SLBaseView {
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = """
Utilize your tokens to temporarily disable limits on distracting apps and stay in control of your productivity.

1 tk = $1
"""
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var tokensTextView: SLTextViewContainer = {
        let view = SLTextViewContainer()
        view.textView.placeholder = "How many tokens would you like to buy?"
        view.bottomText = "Tailor your distraction-free experience by choosing the quantity of credits you'd like to purchase."
        view.textView.keyboardType = .numberPad
        return view
    }()

    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.isEnabled = false
        view.setTitle("Purchase tokens", for: .normal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    private func layoutUI() {
        [button, subtitleLabel, tokensTextView].forEach { addSubview($0) }

        button.snp.makeConstraints({
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        tokensTextView.snp.makeConstraints({
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(0).priority(.low)
        })
    }
}
