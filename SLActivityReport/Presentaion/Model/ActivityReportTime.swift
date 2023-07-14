//
//  TotalTimes.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-12.
//

import Foundation

struct ActivityReportTime {
    let slacked: TimeInterval
    let total: TimeInterval
    let limit: TimeInterval
    
    func getSlackedLimitPercentage() -> Double {
        .init(slacked/limit)
    }
    
    func getSlackedTotalPercentage() -> Double {
        .init(slacked/total)
    }
    
    func getSlackedTotalPercentageText() -> String {
        "\(Int(getSlackedTotalPercentage()*100))%"
    }
    
    func getOtherTotalPercentageText() -> String {
        "\(100-Int(getSlackedTotalPercentage()*100))%"
    }
}
