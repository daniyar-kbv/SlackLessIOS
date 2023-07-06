//
//  SummaryDashboardReport.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-06-23.
//

import Foundation
import SwiftUI

struct SummaryDashboardReport {
    let remainingTime: TimeInterval
    let totalTime: TimeInterval
    
    func getPercentage() -> Double {
        1-(remainingTime/totalTime)
    }
}
