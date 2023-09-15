//
//  Date.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation

extension Date {
    func getDate() -> Date {
        Calendar.current.dateInterval(of: .day, for: self)!.start
    }
    
    func getWeekInterval() -> DateInterval {
        Calendar.current.dateInterval(of: .weekOfYear, for: self)!
    }
    
    func getFirstDayOfWeek() -> Date {
        getWeekInterval().start
    }
    
    func getLastDayOfWeek() -> Date {
        getWeekInterval().end.add(.day, value: -1)
    }
    
    func add(_ component: Calendar.Component, value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    func formatted(style: DateStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = style.format
        return dateFormatter.string(from: self)
    }
    
    func getComponents(_ components: Set<Calendar.Component> = [.day, .month, .year]) -> DateComponents {
        Calendar.current.dateComponents(components, from: self)
    }
    
    func compareByDate(to date: Date) -> ComparisonResult {
        let components1 = self.getComponents()
        let components2 = date.getComponents()
        
        if let year1 = components1.year, let year2 = components2.year {
            if year1 != year2 {
                return year1 < year2 ? .orderedAscending : .orderedDescending
            }
        }
        
        if let month1 = components1.month, let month2 = components2.month {
            if month1 != month2 {
                return month1 < month2 ? .orderedAscending : .orderedDescending
            }
        }
        
        if let day1 = components1.day, let day2 = components2.day {
            if day1 != day2 {
                return day1 < day2 ? .orderedAscending : .orderedDescending
            }
        }
        
        return .orderedSame
    }
}

extension Date {
    enum DateStyle {
        case short
        case long
        
        var format: String {
            switch self {
            case .short: return "d MMM"
            case .long: return "d MMM, EEEE"
            }
        }
    }
}
