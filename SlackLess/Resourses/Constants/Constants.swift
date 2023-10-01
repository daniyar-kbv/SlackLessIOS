//
//  Constants.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import DeviceActivity
import UIKit

//  TODO: Refactor

struct Constants {
    static let screenSize: CGRect = UIScreen.main.bounds

    enum Settings {
        static let appMode: AppMode = .debug
        static let unlockTime: TimeInterval = 10 * 60

        enum AppMode {
            case normal
            case debug
        }
    }

    enum URLs {
        enum ITunesAPI {
            static let search = URL(string: "https://itunes.apple.com")!
        }
    }

    enum ErrorCode {}

    enum StatusCode {
        static let success = 200
        static let unauthorized = 401
    }

    enum DeviceActivity {
        static let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
    }

    enum Payment {
        static let applePayMerchantId = "merchant.kz.slackless"
    }

//    Shared constants
    enum UserDefaults {
        enum SuiteName {
            static let main = "group.kz.slackless"
        }

        enum Key {
            static let appsSelection = "AppsSelection"
        }
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
