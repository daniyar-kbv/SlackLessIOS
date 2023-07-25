//
//  Constants.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit
import DeviceActivity

//  Tech debt: Refactor

struct Constants {
    static let screenSize: CGRect = UIScreen.main.bounds
    static let appMode: AppMode = .normal
    
    enum AppMode {
        case normal
        case debug
    }

    enum URLs {
        struct ITunesAPI {
            static let search = URL(string: "https://itunes.apple.com")!
        }
    }

    enum ErrorCode {}

    enum StatusCode {
        static let success = 200
        static let unauthorized = 401
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
        static let summary = "Summary"
        static let progress = "Progress"
    }
    
    struct DeviceActivityFilters {
        static let summary = DeviceActivityFilter(
            segment: .daily(
                during: Calendar.current.dateInterval(
                   of: .day, for: .now
                )!
            ),
            users: .all,
            devices: .init([.iPhone])
        )
        static let progress = DeviceActivityFilter(
            segment: .weekly(
                during: Calendar.current.dateInterval(
                   of: .weekOfYear, for: .now
                )!
            ),
            users: .all,
            devices: .init([.iPhone])
        )
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
