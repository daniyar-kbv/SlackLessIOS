//
//  SLDeviceActivityEventType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation
import ManagedSettingsUI

//  TODO: Split layer models

struct SLShield: Codable {
    let state: State
    let threshold: TimeInterval
    
    init?(string: String) {
        let components = string.components(separatedBy: "_")
        guard components.count == 2,
              let state = State(rawValue: components[0]),
              let threshold = TimeInterval(components[1])
        else { return nil }
        
        self.state = state
        self.threshold = threshold
    }
    
    init(type: State, threshold: TimeInterval) {
        self.state = type
        self.threshold = threshold
    }
}

extension SLShield {
    enum State: String, Codable {
        case remind
        case lock
        
        var name: String {
            rawValue
        }
        
        var subtitle: String {
            switch self {
            case .remind: return SLTexts.Shield.Subtitle.normal.localized()
            case .lock: return SLTexts.Shield.Subtitle.unlock.localized()
            }
        }
        
        var secondaryButtonLabel: ShieldConfiguration.Label? {
            switch self {
            case .remind: return .init(text: "Annoying",
                                       color: SLColors.white.getColor() ?? .white)
            case .lock: return .init(text: "Locked",
                                       color: SLColors.white.getColor()?.withAlphaComponent(0.5) ?? .white)
            }
        }
    }
}
