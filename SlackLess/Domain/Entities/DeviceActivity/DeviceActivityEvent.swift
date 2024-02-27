//
//  DeviceActivityEvent.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import Foundation

//  TODO: Move to Helper

typealias DeviceActivityEventName = DeviceActivityEvent.Name

extension DeviceActivityEventName {
    static func encode(from shield: SLShield) -> Self {
        Self("\(shield.state.name)_\(shield.threshold)")
    }
    
    func decode() -> SLShield? {
        return .init(string: rawValue)
    }
}
