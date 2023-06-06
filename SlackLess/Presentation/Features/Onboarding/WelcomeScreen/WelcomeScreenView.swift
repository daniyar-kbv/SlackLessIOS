//
//  WelcomeScreenView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-31.
//

import Foundation
import UIKit

final class WelcomeScreenView: UIView {
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
        view.alignment = .fill
        view.distribution = .equalSpacing
        return view
    }()

    private(set) lazy var bottomLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center

        let baseAttriibutes: [NSAttributedString.Key: Any] = [
            .foregroundColor: SLColors.white.getColor() as Any,
            .font: SLFonts.primary.getFont(ofSize: 13, weight: .regular),
        ]
        let accentAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: SLColors.black.getColor() as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: SLColors.black.getColor() as Any,
        ]

        var text1 = NSMutableAttributedString(
            string: SLTexts.WelcomeScreen.termsAndPrivacy1.localized(),
            attributes: baseAttriibutes
        )
        var text2 = NSMutableAttributedString(
            string: SLTexts.WelcomeScreen.termsAndPrivacy2.localized(),
            attributes: baseAttriibutes
        )
        var text3 = NSMutableAttributedString(
            string: SLTexts.WelcomeScreen.termsAndPrivacy3.localized(),
            attributes: baseAttriibutes
        )
        var text4 = NSMutableAttributedString(
            string: SLTexts.WelcomeScreen.termsAndPrivacy4.localized(),
            attributes: baseAttriibutes
        )
        let space = NSAttributedString(string: " ")
        let newLine = NSAttributedString(string: "\n")

        let text2Range = NSRange(location: 0, length: text2.string.count)
        let text4Range = NSRange(location: 0, length: text4.string.count)

        text2.addAttributes(accentAttributes, range: text2Range)
        text4.addAttributes(accentAttributes, range: text4Range)

        text1.append(newLine)
        text1.append(text2)
        text1.append(space)
        text1.append(text3)
        text1.append(space)
        text1.append(text4)

        view.attributedText = text1

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
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.left.right.equalToSuperview()
        }

        mainImage.snp.makeConstraints {
            $0.size.equalTo(safeAreaLayoutGuide.snp.width)
        }

        mainButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}
