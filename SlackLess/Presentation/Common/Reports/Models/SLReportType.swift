//
//  SLReportType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-11.
//

import DeviceActivity
import Foundation
import SwiftUI

enum SLReportType {
    case summary
    case progress
    case weeklyReport

    private var calendar: Calendar {
        .current
    }

    var contextName: String {
        switch self {
        case .summary: return "Summary"
        case .progress: return "Progress"
        case .weeklyReport: return "WeeklyReport"
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
        case .progress, .weeklyReport:
            let currentDate = Date()
            let minusFiveWeeksDate = currentDate.add(.weekOfYear, value: -4)
            let startDate = minusFiveWeeksDate.getWeekInterval().start
            let endDate = currentDate.getWeekInterval().end
            return DeviceActivityFilter(
                segment: .daily(
                    during: .init(start: startDate,
                                  end: endDate)
                ),
                users: .all,
                devices: .init([.iPhone, .iPad])
            )
        }
    }
}
