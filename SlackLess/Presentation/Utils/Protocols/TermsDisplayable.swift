//
//  TermsDisplayable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-04.
//

import Foundation
import UIKit

protocol TermsDisplayable: AnyObject {
    func setUpTerms(label: inout UILabel, accentColor: UIColor?, clickElementName: String, twoLined: Bool)
}

extension UIViewController: TermsDisplayable {
    func setUpTerms(label: inout UILabel, accentColor: UIColor?, clickElementName: String, twoLined: Bool = false) {
        label.attributedText = makeTermsAndPrivacyAttributedText(font: label.font, baseColor: label.textColor, accentColor: accentColor, twoLined: twoLined, clickElementName: clickElementName)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(redirect))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true
    }
    
    @objc fileprivate func redirect(_ sender: UITapGestureRecognizer) {
        guard UIApplication.shared.canOpenURL(Constants.URLs.termsPrivacy) else {
            showError(PresentationError.cantOpenTermsAndPrivacy)
            return
        }
        
        UIApplication.shared.open(Constants.URLs.termsPrivacy)
    }
    
    private func makeTermsAndPrivacyAttributedText(font: UIFont, baseColor: UIColor?, accentColor: UIColor?, twoLined: Bool, clickElementName: String) -> NSAttributedString {
        let baseAttriibutes: [NSAttributedString.Key: Any] = [
            .foregroundColor: baseColor as Any,
            .font: font
        ]
        let accentAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: accentColor as Any,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: accentColor as Any,
        ]

        let text1 = NSMutableAttributedString(
            string: SLTexts.Common.TermsAndPrivacy.text1.localized(clickElementName),
            attributes: baseAttriibutes
        )
        let text2 = NSMutableAttributedString(
            string: SLTexts.Common.TermsAndPrivacy.text2.localized(),
            attributes: baseAttriibutes
        )
        let text3 = NSMutableAttributedString(
            string: SLTexts.Common.TermsAndPrivacy.text3.localized(),
            attributes: baseAttriibutes
        )
        let text4 = NSMutableAttributedString(
            string: SLTexts.Common.TermsAndPrivacy.text4.localized(),
            attributes: baseAttriibutes
        )
        let space = NSAttributedString(string: " ")

        let text2Range = NSRange(location: 0, length: text2.string.count)
        let text4Range = NSRange(location: 0, length: text4.string.count)

        text2.addAttributes(accentAttributes, range: text2Range)
        text4.addAttributes(accentAttributes, range: text4Range)
        
        if twoLined {
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
