//
//  Extensions.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation
import UIKit

extension SLTexts.Common.TermsAndPrivacy {
    static func makeText(clickElementName: String) -> NSAttributedString {
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
            string: Self.text1.localized(clickElementName),
            attributes: baseAttriibutes
        )
        var text2 = NSMutableAttributedString(
            string: Self.text2.localized(),
            attributes: baseAttriibutes
        )
        var text3 = NSMutableAttributedString(
            string: Self.text3.localized(),
            attributes: baseAttriibutes
        )
        var text4 = NSMutableAttributedString(
            string: Self.text4.localized(),
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
        
        return text1
    }
}
