//
//  WelcomeScreenView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-31.
//

import Foundation
import UIKit
import SnapKit

final class WelcomeScreenView: SLView {
    private(set) lazy var mainImage: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.WelcomeScreen.main.getImage()
        return view
    }()

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 34, weight: .bold)
        view.textColor = SLColors.white.getColor()
        view.text = SLTexts.WelcomeScreen.title.localized()
        view.textAlignment = .center
        return view
    }()

    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 22, weight: .bold)
        view.textColor = SLColors.white.getColor()
        view.text = SLTexts.WelcomeScreen.subtitle.localized()
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    private(set) lazy var titlesStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .center
        return view
    }()

    private(set) lazy var mainButton: SLButton = {
        let view = SLButton(style: .white, size: .large)
        return view
    }()

    private(set) lazy var mainStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [mainImage, titlesStack, mainButton, bottomLabel])
        view.axis = .vertical
        view.spacing = 32
        view.alignment = .center
        view.distribution = .equalSpacing
        view.clipsToBounds = false
        return view
    }()

    private(set) lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.attributedText = SLTexts.Common.TermsAndPrivacy.makeText(clickElementName: mainButton.titleLabel?.text ?? "")
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
        backgroundColor = SLColors.accent1Static.getColor()

        [mainStack].forEach { addSubview($0) }

        mainStack.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }

        mainImage.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.size.equalTo(self.snp.width).offset(16).priority(.required)
        }

        mainButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().priority(.high)
            $0.width.equalToSuperview()
        }
    }
}
