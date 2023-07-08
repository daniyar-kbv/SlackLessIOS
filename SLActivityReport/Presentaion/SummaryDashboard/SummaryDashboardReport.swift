//
//  SummaryDashboardReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-23.
//

import Foundation
import SwiftUI

struct SummaryReport {
    let spentTime: TimeInterval
    let timeLimit: TimeInterval
    
    func getPercentage() -> Double {
        spentTime/timeLimit
    }
    
    func getFormattedSpentTime() -> String {
        return "\(spentTime.getHours()):\(spentTime.getRemainderMinutes()<10 ? " " : "")\(spentTime.getRemainderMinutes())"
    }
    
    func getFormattedTimeLimit() -> String {
        "\(timeLimit.getHours())h"
    }
}
