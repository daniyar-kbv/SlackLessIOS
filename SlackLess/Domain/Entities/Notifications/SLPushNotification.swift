//
//  SLPushNotification.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-07.
//

import Foundation

struct SLPushNotification {
    var type: SLPushNotificationType
    var state: State
    
    enum State {
        case foreground
        case background
    }
}
