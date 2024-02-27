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
        
        func getSubtitle(with timeValue: TimeInterval? = nil) -> String {
            guard let timeValue = timeValue?.formatted(with: .full) else {
                switch self {
                case .remind: return SLTexts.Shield.Subtitle.Remind.defaultText.localized()
                case .lock: return SLTexts.Shield.Subtitle.Lock.defaultText.localized()
                }
            }
            
            switch self {
            case .remind: return SLTexts.Shield.Subtitle.Remind.allCases.randomElement()!.localized(timeValue)
            case .lock: return SLTexts.Shield.Subtitle.Lock.allCases.randomElement()!.localized(timeValue)
            }
        }
        
        func getPrimaryButtonTitle() -> String {
            switch self {
            case .remind: return SLTexts.Shield.PrimaryButtonTitle.remind.localized()
            case .lock: return SLTexts.Shield.PrimaryButtonTitle.lock.localized()
            }
        }
        
        func getSecondaryButtonTitle(with timeValue: TimeInterval) -> String {
            switch self {
            case .remind: return SLTexts.Shield.SecondaryButtonTitle.remind.localized()
            case .lock: return SLTexts.Shield.SecondaryButtonTitle.lock.localized(timeValue.formatted(with: .full) ?? "")
            }
        }
    }
}
