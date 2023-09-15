//
//  MockData.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation


struct MockData {
    private static let appNames = ["Instagram", "Pinterest", "TikTok", "WhatsApp", "Facebook", "Telegram", "LinkedIn", "Poker Shark", "Slack", "Google", "YouTube"]
    
    static func getDay() -> ARDay {
        let num = Int.random(in: 1...20)
        let date = Date()
        let time = ARTime(slacked: Double.random(in: 1000...10000),
                          total: Double.random(in: 10000...20000),
                          limit: 10000,
                          average: nil)
        let times = (0..<num).map({ _ in TimeInterval.random(in: 60...14400) })
        let minTime = times.min() ?? 0
        let maxTime = times.max() ?? 0
        let apps = (0..<num)
            .map({ appNum in
                return ARApp(name: appNames.randomElement() ?? "",
                             time: times[appNum],
                             ratio: times.count > 1 ? (times[appNum]-minTime)/(maxTime-minTime) : 0.5)
            })
            .sorted(by: { $0.time > $1.time })
        return .init(date: date,
                     time: time,
                     selectedApps: apps,
                     otherApps: apps)
    }
    
//    static func getWeeks() -> [ARWeek] {
//        let weeks = (Int(0)..<Int(5)).reversed().map({ week in
//            var days = [ARWeek.Day]()
//            let calendar = Calendar.current
//            let today = Date()
//            let firstDayOfWeek = calendar.date(byAdding: .weekOfYear, value: -week, to: today.getFirstDayOfWeek())!
//            let startingDate = firstDayOfWeek.getLastDayOfWeek()
//            guard week < 4 else {
//                return ARWeek(startDate: firstDayOfWeek, days: (0..<7).map({
//                    let date = calendar.date(byAdding: .day, value: -$0, to: startingDate)!
//                    return .init(weekday: calendar.component(.weekday, from: date), time: .init(slacked: 0, total: 0, limit: 0, average: 0))
//                    
//                }))
//            }
//            for (index, day) in getDays(isRandom: true).enumerated() {
//                let date = calendar.date(byAdding: .day, value: -index, to: startingDate)!
//                guard date <= today else {
//                    days.append(.init(weekday: calendar.component(.weekday, from: date),
//                                      time: .init(slacked: 0, total: 0, limit: 0, average: 0)))
//                    continue
//                }
//                days.append(.init(weekday: calendar.component(.weekday, from: date),
//                                  time: day.time))
//            }
//            return .init(startDate: firstDayOfWeek, days: days.reversed())
//        })
//        return weeks
//    }
}
