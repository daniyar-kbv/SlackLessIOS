//
//  ARTime.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-12.
//

import Foundation

struct ARTime {
    let slacked: TimeInterval
    let total: TimeInterval
    let limit: TimeInterval?
    let average: TimeInterval?

    func getSlackedLimitPercentage() -> Double? {
        guard let limit else { return nil }
        return .init(slacked / limit)
    }

    func getSlackedTotalPercentage() -> Double {
        guard slacked > 0 && total > 1 else { return 0 }
        return .init(slacked / total)
    }

    func getSlackedTotalPercentageText() -> String {
        "\(Int(getSlackedTotalPercentage() * 100))%"
    }

    func getOtherTotalPercentageText() -> String {
        "\(100 - Int(getSlackedTotalPercentage() * 100))%"
    }
}
