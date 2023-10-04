//
//  SLShieldState.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation
import ManagedSettingsUI

enum SLShieldState {
    case normal
    case unlock
    
    init(rawValue: Int?) {
        switch rawValue {
        case Self.unlock.rawValue: self = .unlock
        default: self = .normal
        }
    }
    
    var rawValue: Int {
        switch self {
        case .normal: return 1
        case .unlock: return 2
        }
    }
    
    var subtitle: String {
        switch self {
        case .normal: return SLTexts.Shield.Subtitle.normal.localized()
        case .unlock: return SLTexts.Shield.Subtitle.unlock.localized()
        }
    }
    
    var secondaryButtonLabel: ShieldConfiguration.Label? {
        switch self {
        case .normal: return .init(text: SLTexts.Shield.secondaryButtonTitle.localized(),
                                   color: SLColors.white.getColor() ?? .white)
        case .unlock: return .init(text: SLTexts.Shield.secondaryButtonTitle.localized(),
                                   color: SLColors.white.getColor()?.withAlphaComponent(0.5) ?? .white)
        }
    }
}
