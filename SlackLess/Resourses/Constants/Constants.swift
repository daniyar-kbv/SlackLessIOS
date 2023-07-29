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

extension Constants {
    struct DeviceActivityFilters {
        private static var today = Date()
        
        static let summary = DeviceActivityFilter(
            segment: .daily(
                during: .init(start: Calendar.current.date(byAdding: .day, value: -6, to: Date())!,
                              end: Date())
            ),
            users: .all,
            devices: .init([.iPhone])
        )
        static let progress = DeviceActivityFilter(
            segment: .daily(
                during: .init(start: Calendar.current.date(byAdding: .weekOfYear, value: -4, to: Date().getFirstDayOfWeek())!,
                              end: Date().getLastDayOfWeek())
            ),
            users: .all,
            devices: .init([.iPhone])
        )
    }
}
