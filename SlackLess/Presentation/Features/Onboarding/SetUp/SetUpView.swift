//
//  SetUpView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-22.
//

import Foundation
import SnapKit
import UIKit

final class SetUpView: SLView {
    private(set) lazy var largeTitleView: SLLargeTitleView = {
        let view = SLLargeTitleView()
        view.title = SLTexts.SetUp.title.localized()
        view.subtitle = SLTexts.SetUp.subtitle.localized()
        return view
    }()

    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.setTitle(SLTexts.Button.continue_.localized(), for: .normal)
        return view
    }()

    private(set) lazy var bottomTextLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.SetUp.bottomText.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    private func layoutUI() {
        [button, bottomTextLabel, largeTitleView].forEach { addSubview($0) }

        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        bottomTextLabel.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        largeTitleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomTextLabel.snp.top)
        }
    }
}
