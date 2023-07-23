//
//  ARWeek.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation

protocol GraphRepresentable {
    func getDateText() -> String
    func getSlackedTimeFormatted() -> String?
    func getTotalTime() -> TimeInterval
    func getTotalTimeFormatted() -> String?
    func getPercentage() -> Double
}

struct ARWeek {
    let startDate: Date
    let days: [Day]
    
    func getTime() -> ARTime {
        ARTime(slacked: days.map({ $0.time.slacked }).reduce(0, +),
               total: days.map({ $0.time.total }).reduce(0, +),
               limit: nil,
               average: days.map({ $0.time.total }).reduce(0, +)/Double(days.count))
    }
}

extension ARWeek {
    struct Day: GraphRepresentable {
        let weekday: Int
        let time: ARTime
        
        func getDateText() -> String {
            let calendar = Calendar.current
            let weekdays = calendar.veryShortWeekdaySymbols
            return weekdays[weekday-1]
        }
        
        func getSlackedTimeFormatted() -> String? {
            time.slacked.formatted(with: .abbreviated)
        }
        
        func getTotalTime() -> TimeInterval {
            time.total
        }
        
        func getTotalTimeFormatted() -> String? {
            time.total.formatted(with: .abbreviated)
        }
        
        func getPercentage() -> Double {
            time.getSlackedTotalPercentage()
        }
    }
}

extension ARWeek: GraphRepresentable {
    func getDateText() -> String {
        let startDateFormatted = startDate.formatted(style: .short)
        let endDateFormatted = startDate.getLastDayOfWeek().formatted(style: .short)
        return "\(startDateFormatted) - \(endDateFormatted)"
    }
    
    func getSlackedTimeFormatted() -> String? {
        getTime().slacked.formatted(with: .abbreviated)
    }
    
    func getTotalTime() -> TimeInterval {
        getTime().total
    }
    
    func getTotalTimeFormatted() -> String? {
        getTime().total.formatted(with: .abbreviated)
    }
    
    func getPercentage() -> Double {
        getTime().getSlackedTotalPercentage()
    }
}
