//
//  SummarySelectedAppsDashboardReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-23.
//

import Foundation
import SwiftUI

struct SummaryReport {
    let spentTime: Int
    let timeLimit: Int
    
    func getPercentage() -> Double {
        Double(spentTime)/Double(timeLimit)
    }
    
    func getFormattedSpentTime() -> String {
        return "\(spentTime.getHours()):\(spentTime.getRemaindingMinutes()<10 ? " " : "")\(spentTime.getRemaindingMinutes())"
    }
    
    func getFormattedTimeLimit() -> String {
        "\(timeLimit.getHours())h"
    }
}
