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
        
        func getSubtitle(with timeValue: TimeInterval) -> String {
            SLTexts.Shield.Subtitle.get(for: self).localized(timeValue.formatted(with: .full) ?? "")
        }
        
        func getSecondaryButtonLabel(with timeValue: TimeInterval) -> ShieldConfiguration.Label {
            var text = String()
            switch self {
            case .remind: text = SLTexts.Shield.SecondaryButtonTitle.remind.localized()
            case .lock: text = SLTexts.Shield.SecondaryButtonTitle.lock.localized(timeValue.formatted(with: .full) ?? "")
            }
            return .init(text: text,
                         color: SLColors.white.getColor() ?? .white)
        }
    }
}
