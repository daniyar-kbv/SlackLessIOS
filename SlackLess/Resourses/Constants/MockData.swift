//
//  MockData.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation


struct MockData {
    static func getDays() -> [ActivityReportDay] {
        let time = ActivityReportTime(slacked: 4800, total: 19500, limit: 10800)
        let minTime = 60.0
        let maxTime = 6000.0
        let num = 20
        let apps = (0..<num)
            .reversed()
                .map({
                    let time = minTime+((maxTime-minTime)/Double(num)*Double($0))
                    return ActivityReportApp(name: "App \($0)",
                                 icon: nil,
                                 time: time,
                                 ratio: (time-minTime)/(maxTime-minTime))
                })
        return (0..<7).reversed().map({
            let date = Calendar.current.date(byAdding: .day, value: Int(-$0), to: Date())
            return .init(date: date ?? Date(),
                  time: time,
                  selectedApps: apps,
                  otherApps: apps)
        })
    }
}
