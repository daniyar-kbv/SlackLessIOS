//
//  MockData.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation


struct MockData {
    private static let appNames = ["Instagram", "Pinterest", "TikTok", "WhatsApp", "Facebook", "Telegram", "LinkedIn", "Poker Shark", "Slack", "Google", "YouTube"]
    
    static func getDays(isRandom: Bool) -> [ARDay] {
        let nums = isRandom ? (0..<7).map({ _ in Int.random(in: 1...20) }) :  [1, 2, 3, 4, 5, 10, 15]
        return (0..<7).reversed().map({ day in
            let date = Calendar.current.date(byAdding: .day, value: Int(-day), to: Date())
            let time = ARTime(slacked: Double.random(in: 1000...10000),
                              total: Double.random(in: 10000...20000),
                              limit: 10000,
                              average: nil)
            let times = (0..<nums[day]).map({ _ in TimeInterval.random(in: 60...14400) })
            let minTime = times.min() ?? 0
            let maxTime = times.max() ?? 0
            let apps = (0..<nums[day])
                .map({ appNum in
                    return ARApp(name: appNames.randomElement() ?? "",
                                 time: times[appNum],
                                 ratio: times.count > 1 ? (times[appNum]-minTime)/(maxTime-minTime) : 0.5)
                })
                .sorted(by: { $0.time > $1.time })
            return .init(date: date ?? Date(),
                  time: time,
                  selectedApps: apps,
                  otherApps: apps)
        })
    }
    
    static func getWeeks() -> [ARWeek] {
        return (Int(0)..<Int(5)).map({ week in
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .weekOfYear, value: -week, to: Date())!
            return .init(startDate: date.getFirstDayOfWeek(),
                         days: getDays(isRandom: true).map({ day in
                ARWeek.Day(weekday: calendar.component(.weekday, from: day.date),
                           time: day.time)
            }))
        })
    }
}
