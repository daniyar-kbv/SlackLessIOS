//
//  SummaryDashboardReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-23.
//

import Foundation
import SwiftUI

struct SummaryDashboardReport {
    let spentTime: TimeInterval
    let timeLimit: TimeInterval
    
    func getPercentage() -> Double {
        spentTime/timeLimit
    }
    
    func getFormattedSpentTime() -> String {
        let totalMinutes = spentTime/60
        let remainderMinutes = Int(totalMinutes.truncatingRemainder(dividingBy: 3600))
        return "\(getHours(from: spentTime)):\(remainderMinutes<10 ? " " : "")\(remainderMinutes)"
    }
    
    func getFormattedTimeLimit() -> String {
        "\(getHours(from: timeLimit))h"
    }
    
    private func getHours(from timeInterval: Double) -> String {
        String(Int(timeInterval/3600))
    }
}
