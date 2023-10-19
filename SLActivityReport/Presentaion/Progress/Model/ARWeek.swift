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
    func getIsCurrent() -> Bool
}

class ARWeek {
    let startDate: Date
    var days: [Day]

    init(startDate: Date, days: [Day]) {
        self.startDate = startDate
        self.days = days
    }

    func getTime() -> ARTime {
        ARTime(slacked: days.map { $0.time.slacked }.reduce(0, +),
               total: days.map { $0.time.total }.reduce(0, +),
               limit: nil,
               average: days.map { $0.time.total }.reduce(0, +) / 7)
    }
}

extension ARWeek {
    struct Day: GraphRepresentable {
        let date: Date
        let time: ARTime

        func getDateText() -> String {
            let calendar = Calendar.current
            let weekdays = calendar.veryShortWeekdaySymbols
            return weekdays[getWeekday() - 1]
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

        func getIsCurrent() -> Bool {
            Calendar.current.component(.weekday, from: Date()) == getWeekday()
        }
        
        func getWeekday() -> Int {
            date.getComponents([.weekday]).weekday ?? 1
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

    func getIsCurrent() -> Bool {
        startDate.getWeekInterval().containsDate(Date())
    }
}
