//
//  MockData.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation


struct MockData {
    private static let appNames = ["Instagram", "Pinterest", "TikTok", "WhatsApp", "Facebook", "Telegram", "LinkedIn", "Poker Shark", "Slack", "Google", "YouTube"]
    
    static func getDays() -> [ARDay] {
        return (0..<7).reversed().map({
            let date = Calendar.current.date(byAdding: .day, value: Int(-$0), to: Date())
            let time = ARTime(slacked: Double.random(in: 1000...10000), total: Double.random(in: 10000...20000), limit: 10000)
            let minTime = Double.random(in: 60...3600)
            let maxTime = Double.random(in: 7200...14400)
            let num = Int.random(in: 1...20)
            let apps = (0..<num)
                .reversed()
                .map({
                    let time = minTime+((maxTime-minTime)/Double(num)*Double($0))
                    return ARApp(name: appNames.randomElement() ?? "",
                                 time: time,
                                 ratio: (time-minTime)/(maxTime-minTime))
                })
            return .init(date: date ?? Date(),
                  time: time,
                  selectedApps: apps,
                  otherApps: apps)
        })
    }
}
