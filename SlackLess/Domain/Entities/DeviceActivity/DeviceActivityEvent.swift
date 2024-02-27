//
//  DeviceActivityEvent.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import Foundation

//  TODO: Move to Helper

extension DeviceActivityEvent.Name {
    static func encode(type: SLDeviceActivityEventType, threshold: TimeInterval) -> Self {
        Self("\(type.name)_\(threshold)")
    }
    
    func decode() -> (type: SLDeviceActivityEventType, threshold: TimeInterval)? {
        let components = rawValue.components(separatedBy: "_")
        guard components.count == 2,
              let type = SLDeviceActivityEventType(rawValue: components[0]),
              let threshold = TimeInterval(components[1])
        else { return nil }
        return (type: type, threshold: threshold)
    }
}
