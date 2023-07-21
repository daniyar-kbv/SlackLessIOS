//
//  ARWeek.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation

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
    struct Day {
        let weekday: Int
        let time: ARTime
    }
}
