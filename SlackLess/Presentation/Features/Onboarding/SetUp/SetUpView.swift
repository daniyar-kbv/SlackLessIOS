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
        view.numberOfLines = 0
        return view
    }()

    private(set) lazy var settingsView = UIView()

    private(set) lazy var titlesStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 8
        view.alignment = .fill
        view.layoutMargins = .init(top: 0, left: 32, bottom: 0, right: 32)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()

    private(set) lazy var mainStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titlesStackView, settingsView])
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 32
        view.alignment = .fill
        return view
    }()

    private(set) lazy var topView = UIView()

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
        [button, bottomTextLabel, topView].forEach { addSubview($0) }

        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        bottomTextLabel.snp.makeConstraints {
            $0.bottom.equalTo(button.snp.top).offset(-8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        topView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomTextLabel.snp.top)
        }

        topView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.centerY.horizontalEdges.equalToSuperview()
        }
    }
}
