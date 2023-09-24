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
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.text = SLTexts.SetUp.title.localized()
        view.textColor = SLColors.accent1.getColor()
        return view
    }()

    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.SetUp.subtitle.localized()
        return view
    }()

    private(set) lazy var settingsView = UIView()

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
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    private func layoutUI() {
        [settingsView, button].forEach { addSubview($0) }

        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        settingsView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }
    }
}
