//
//  String+Extension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit

extension String {
    func format(with mask: String) -> String {
        let numbers = replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex

        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

extension String {
    func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d{2})",
                                    with: "$1 ($2) $3 $4 $5",
                                    options: .regularExpression,
                                    range: nil)
    }
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }

    var containEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600 ... 0x1F64F, // Emoticons
                 0x1F300 ... 0x1F5FF, // Misc Symbols and Pictographs
                 0x1F680 ... 0x1F6FF, // Transport and Map
                 0x1F1E6 ... 0x1F1FF, // Regional country flags
                 0x2600 ... 0x26FF, // Misc symbols
                 0x2700 ... 0x27BF, // Dingbats
                 0xE0020 ... 0xE007F, // Tags
                 0xFE00 ... 0xFE0F, // Variation Selectors
                 0x1F900 ... 0x1F9FF, // Supplemental Symbols and Pictographs
                 127_000 ... 127_600, // Various asian characters
                 65024 ... 65039, // Variation selector
                 9100 ... 9300, // Misc items
                 8400 ... 8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }

    var containsSpecialCharacter: Bool {
        let characters = "[]{}#%^*+=_\'|'~<>$€£•.,?!’-/:;()₽&@“„‚"
        for chr in characters {
            if contains(chr) || contains("|") {
                return true
            }
        }
        return false
    }
}
