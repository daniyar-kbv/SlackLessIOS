//
//  Constants.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import DeviceActivity
import UIKit

//  TODO: Refactor

struct Constants {
    static let screenSize: CGRect = UIScreen.main.bounds

    enum Settings {
        static let appMode: AppMode = .debug
        static let unlockMinutes: Int = 10
        
        static let environmentType: EnvironmentType = {
            #if targetEnvironment(simulator)
            .simulator
            #elseif DEBUG
            .device
            #else
            Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" ? .testFlight : .production
            #endif
        }()

        enum AppMode {
            case normal
            case debug
        }
        
        enum EnvironmentType {
            case simulator
            case device
            case testFlight
            case production
        }
    }

    enum URLs {
        static let termsPrivacy = URL(string: "https://docs.google.com/document/d/1BfIia5RW9RQG0aqWUFCyWI3ZLoDh-HnR3EKsM5r3EW0/edit?usp=sharing")!
    }

    enum ErrorCode {}

    enum StatusCode {
        static let success = 200
        static let unauthorized = 401
    }
    
    enum Payment {
        static let applePayMerchantId = "merchant.kz.slackless"
    }

//    Shared constants
    enum SharedStorage {
        static let appGroup = "group.kz.slackless"
        static let databaseName = "SlackLess"
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
