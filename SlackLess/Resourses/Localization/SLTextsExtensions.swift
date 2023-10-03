//
//  Extensions.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation
import UIKit

extension SLTexts.Common.TermsAndPrivacy {
    static func makeText(font: UIFont, baseColor: UIColor?, accentColor: UIColor?, split: Bool, clickElementName: String) -> NSAttributedString {
        let baseAttriibutes: [NSAttributedString.Key: Any] = [
            .foregroundColor: baseColor as Any,
            .font: font,
        ]
        let accentAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: accentColor as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: accentColor as Any,
        ]

        let text1 = NSMutableAttributedString(
            string: Self.text1.localized(clickElementName),
            attributes: baseAttriibutes
        )
        let text2 = NSMutableAttributedString(
            string: Self.text2.localized(),
            attributes: baseAttriibutes
        )
        let text3 = NSMutableAttributedString(
            string: Self.text3.localized(),
            attributes: baseAttriibutes
        )
        let text4 = NSMutableAttributedString(
            string: Self.text4.localized(),
            attributes: baseAttriibutes
        )
        let space = NSAttributedString(string: " ")

        let text2Range = NSRange(location: 0, length: text2.string.count)
        let text4Range = NSRange(location: 0, length: text4.string.count)

        text2.addAttributes(accentAttributes, range: text2Range)
        text4.addAttributes(accentAttributes, range: text4Range)
        if split {
            let newLine = NSAttributedString(string: "\n")
            text1.append(newLine)
        } else {
            text1.append(space)
        }
        text1.append(text2)
        text1.append(space)
        text1.append(text3)
        text1.append(space)
        text1.append(text4)
        
        return text1
    }
}
