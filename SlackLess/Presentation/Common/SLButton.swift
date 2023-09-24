//
//  SLButton.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-01.
//

import Foundation
import UIKit

final class SLButton: UIButton {
    private let style: Style
    private let size: Size

    init(style: Style,
         size: Size)
    {
        self.style = style
        self.size = size

        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        titleLabel?.font = SLFonts.primary.getFont(ofSize: 17, weight: .bold)

        setBackgroundColor(color: style.getBackgroundColor(for: .normal), forState: .normal)
        setBackgroundColor(color: style.getBackgroundColor(for: .highlighted), forState: .highlighted)
        setBackgroundColor(color: style.getBackgroundColor(for: .disabled), forState: .disabled)

        setTitle(SLTexts.WelcomeScreen.buttonText.localized(), for: .normal)
        setTitleColor(style.getTextColor(for: .normal), for: .normal)
        setTitleColor(style.getTextColor(for: .highlighted), for: .highlighted)
        setTitleColor(style.getTextColor(for: .disabled), for: .disabled)

        layer.cornerRadius = size.cornerRadius

        snp.makeConstraints { [weak self] in
            $0.height.equalTo(self?.size.height ?? 0).priority(.required)
        }
    }
}

extension SLButton {
    enum Style {
        case filled
        case tinted
        case gray
        case white
        case contrastBackground
        case contrastText
        case plain

        private var backgroundColor: UIColor? {
            switch self {
            case .filled: return SLColors.accent1.getColor()
            case .tinted: return SLColors.accent3.getColor()
            case .gray: return SLColors.accent4.getColor()
            case .white: return SLColors.white.getColor()
            case .contrastBackground: return SLColors.backgroundContrast.getColor()
            case .contrastText: return SLColors.backgroundElevated.getColor()
            case .plain: return .clear
            }
        }

        private var textColor: UIColor? {
            switch self {
            case .filled: return SLColors.label2.getColor()
            case .tinted: return SLColors.accent1.getColor()
            case .gray: return SLColors.accent1.getColor()
            case .white: return SLColors.black.getColor()
            case .contrastBackground: return SLColors.label2.getColor()
            case .contrastText: return SLColors.label2.getColor()
            case .plain: return SLColors.accent1.getColor()
            }
        }

        enum State {
            case normal
            case highlighted
            case disabled
        }

        func getBackgroundColor(for state: State) -> UIColor? {
            switch state {
            case .normal: return backgroundColor
            default: return backgroundColor?.withAlphaComponent(0.5)
            }
        }

        func getTextColor(for state: State) -> UIColor? {
            switch state {
            case .normal: return textColor
            default: return textColor?.withAlphaComponent(0.5)
            }
        }
    }

    enum Size {
        case large
        case medium
        case small

        var height: CGFloat {
            switch self {
            case .large: return 60
            case .medium: return 46
            case .small: return 36
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .large: return 13
            default: return height / 2
            }
        }
    }
}
