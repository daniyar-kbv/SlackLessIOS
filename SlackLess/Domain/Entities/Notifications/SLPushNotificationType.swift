//
//  SLPushNotification.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-07.
//

import Foundation
import UserNotifications

enum SLPushNotificationType: String {
    case test
    
    init?(notification: UNNotification) {
        let rawValue = Self.decode(identifier: notification.request.identifier)
        self.init(rawValue: rawValue ?? "")
    }
    
    var title: String {
        switch self {
        case .test: return "Test title"
        }
    }
    
    var body: String {
        switch self {
        case .test: return "Test body"
        }
    }
    
    var trigger: UNNotificationTrigger {
        switch self {
        case .test:
            return UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                     repeats: false)
        }
    }
    
    func makeRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        return UNNotificationRequest(identifier: codeIdentifier(),
                                     content: content,
                                     trigger: trigger)
    }
    
    private func codeIdentifier() -> String {
        "\(self):\(UUID().uuidString)"
    }
    
    private static func decode(identifier: String) -> String? {
        identifier.components(separatedBy: ":").first
    }
}
