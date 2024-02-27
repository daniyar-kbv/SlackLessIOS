//
//  SLDeviceActivityEventType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation

enum SLDeviceActivityEventType: String {
    case annoy
    case lock
    
    var name: String {
        rawValue
    }
}
