//
//  ResultsState.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import UIKit

enum ResultsState {
    case spend(year: String?, life: String?)
    case save(life: String?)
    
    var backgroundColor: UIColor? {
        switch self {
        case .spend: return SLColors.background1.getColor()
        case .save: return SLColors.accent1.getColor()
        }
    }
    
    var topTitle: NSMutableAttributedString {
        switch self {
        case let .spend(year, _):
            let timeString = year ?? ""
            let mainString = SLTexts.Results.TopTitle.spend.localized(timeString)
            let mutableAttributedString = NSMutableAttributedString(string: mainString)
            
            let timeRange = (mainString as NSString).range(of: timeString)
            mutableAttributedString.addAttribute(.foregroundColor,
                                                 value: SLColors.accent1.getColor() ?? .blue,
                                                 range: timeRange)
            mainString
                .split(separator: timeString)
                .forEach({
                    let range = (mainString as NSString).range(of: String($0))
                    mutableAttributedString.addAttribute(.foregroundColor,
                                                         value: textColor ?? .black,
                                                         range: range)
                })

            return mutableAttributedString
        case .save:
            let mainString = SLTexts.Results.TopTitle.save.localized()
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: textColor ?? .white
            ]
            let mutableAttributedString = NSMutableAttributedString(string: mainString,
                                                                    attributes: attributes)
            
            return mutableAttributedString
        }
    }
    
    var bottomTitle: String {
        switch self {
        case .spend: return SLTexts.Results.BottomTitle.spend.localized()
        case .save: return SLTexts.Results.BottomTitle.save.localized()
        }
    }
    
    var valueColor: UIColor? {
        switch self {
        case .spend: return SLColors.accent1.getColor()
        case .save: return SLColors.white.getColor()
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .spend: return SLTexts.Results.ButtonTitle.spend.localized()
        case .save: return SLTexts.Results.ButtonTitle.save.localized()
        }
    }
    
    var buttonColor: UIColor? {
        switch self {
        case .spend: return SLColors.backgroundElevated.getColor()
        case .save: return SLColors.white.getColor()
        }
    }
    
    var textColor: UIColor? {
        switch self {
        case .spend: return SLColors.label1.getColor()
        case .save: return SLColors.white.getColor()
        }
    }
}
