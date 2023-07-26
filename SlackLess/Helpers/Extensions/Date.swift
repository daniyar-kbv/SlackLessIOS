//
//  Date.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation

extension Date {
    func getFirstDayOfWeek() -> Date {
        return Calendar(identifier: .gregorian)
            .dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)
            .date!
    }
    
    func getLastDayOfWeek() -> Date {
        return Calendar
            .current
            .date(byAdding: .day,
                  value: 6,
                  to: getFirstDayOfWeek())!
    }
    
    func formatted(style: DateStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = style.format
        return dateFormatter.string(from: self)
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
