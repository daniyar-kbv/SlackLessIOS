//
//  SLDeviceActivityReport.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-11.
//

import Foundation
import SwiftUI
import DeviceActivity

enum SLDeviceActivityReportType {
    case summary
    case week
    case pastWeeks
    
    private var calendar: Calendar {
        .current
    }
    
    var contextName: String {
        switch self {
        case .summary: return "Summary"
        case .week: return "Week"
        case .pastWeeks: return "PastWeeks"
        }
    }
    
    func getContext() -> DeviceActivityReport.Context {
        .init(contextName)
    }
    
    func getFilter(for date: Date? = nil) -> DeviceActivityFilter {
        switch self {
        case .summary:
            return DeviceActivityFilter(
                segment: .daily(
                    during: Calendar.current.dateInterval(
                        of: .day, for: date ?? Date()
                     )!
                ),
                users: .all,
                devices: .init([.iPhone])
            )
        case .week:
            let minusWeekDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
            let startDate = calendar.dateInterval(of: .weekOfYear, for: minusWeekDate)!.start
            let endDate = calendar.dateInterval(of: .weekOfYear, for: Date())!.end
            return DeviceActivityFilter(
                segment: .daily(
                    during: .init(start: startDate,
                                  end: endDate)
                ),
                users: .all,
                devices: .init([.iPhone])
            )
        case .pastWeeks:
            let minusFiveWeeksDate = calendar.date(byAdding: .weekOfYear, value: -4, to: Date())!
            let startDate = calendar.dateInterval(of: .weekOfYear, for: minusFiveWeeksDate)!.start
            let endDate = calendar.dateInterval(of: .weekOfYear, for: Date())!.end
            return DeviceActivityFilter(
                segment: .weekly(
                    during: .init(start: startDate,
                                  end: endDate)
                ),
                users: .all,
                devices: .init([.iPhone])
            )
        }
    }
}
