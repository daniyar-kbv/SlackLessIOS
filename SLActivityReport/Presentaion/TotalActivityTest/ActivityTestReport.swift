//
//  ActivityTestReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-04.
//

import Foundation
import SwiftUI

struct ActivityTestReport {
    let totalDuration: TimeInterval
    let apps: [AppDeviceTestActivity]
}

struct AppDeviceTestActivity: Identifiable {
    var id: String
    var displayName: String
    var duration: TimeInterval
    var numberOfPickups: Int
}

extension TimeInterval{
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d",hours,minutes)
    }
}
