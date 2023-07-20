//
//  ARWeek.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation

struct ARWeek {
    let startDate: Date
    let endDate: Date
    let days: [Day]
    
    func getStackedTime() -> TimeInterval {
        return days.map({ $0.time.slacked }).reduce(0, +)
    }
    
    func getTotalTime() -> TimeInterval {
        return days.map({ $0.time.total }).reduce(0, +)
    }
    
    func getAverageTime() -> TimeInterval {
        return getTotalTime() / Double(days.count)
    }
}

extension ARWeek {
    struct Day {
        let weekday: Weekday
        let time: ARTime
        
        enum Weekday: String {
            case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        }
    }
}
