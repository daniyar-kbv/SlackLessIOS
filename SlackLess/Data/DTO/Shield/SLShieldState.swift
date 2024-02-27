//
//  SLShieldState.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation
import ManagedSettingsUI

enum SLShieldState: Int {
    case normal
    case unlock
    
    var subtitle: String {
        switch self {
        case .normal: return SLTexts.Shield.Subtitle.normal.localized()
        case .unlock: return SLTexts.Shield.Subtitle.unlock.localized()
        }
    }
    
    var secondaryButtonLabel: ShieldConfiguration.Label? {
        switch self {
        case .normal: return .init(text: "Annoying",
                                   color: SLColors.white.getColor() ?? .white)
        case .unlock: return .init(text: "Locked",
                                   color: SLColors.white.getColor()?.withAlphaComponent(0.5) ?? .white)
        }
    }
}
