//
//  Constants.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit

//  Tech debt: refactor

struct Constants {
    static let screenSize: CGRect = UIScreen.main.bounds
    
    enum AppMode {
        case normal
        case experimental
    }

    enum URLs {}

    enum ErrorCode {}

    enum StatusCode {
        static let success = 200
        static let unauthorized = 401
    }

    enum InternalNotification {
        var name: Notification.Name {
            switch self {}
        }
    }
    
//    Shared constants
    struct UserDefaults {
        struct SuiteName {
            static let main = "group.kz.slackless"
        }
        
        struct Key {
            static let appsSelection = "AppsSelection"
        }
    }
    
    struct ContextName {
        static let mainDashboard = "MainDashboard"
    }
}

extension Constants {
    private static func getPlistValue(by key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "ABInfo", ofType: "plist") else {
            fatalError("Couldn't find file 'SLInfo.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'SLInfo.plist'.")
        }
        return value
    }
}
