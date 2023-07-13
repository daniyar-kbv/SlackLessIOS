//
//  TotalTimes.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-12.
//

import Foundation

struct TotalTimes {
    let totalTime: Int
    let slackedTime: Int
    
    func getTotalTimeFormatted() -> String {
        return "\(totalTime.getHours())h \(totalTime.getRemaindingMinutes())"
    }
    
    func getSlackedPercentage() -> Int {
        Int(Double(slackedTime)/Double(totalTime)*100)
    }
    
    func getOtherAppsPercentage() -> Int {
        100-getSlackedPercentage()
    }
}
