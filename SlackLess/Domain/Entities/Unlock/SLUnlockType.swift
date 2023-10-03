//
//  SLLockUpdateType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-02.
//

import Foundation

enum SLLockUpdateType {
    case refresh
    case shortUnlock
    case longUnlock
    
    var unlockTime: TimeInterval {
        switch self {
        case .refresh: return 0
        case .shortUnlock: return Constants.Settings.shortUnlockTime
        case .longUnlock: return Constants.Settings.unlockTime
        }
    }
}
