//
//  DayData.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-07.
//

import Foundation
import CoreData
import FamilyControls

struct DayData: Codable {
    var date: Date
    var selectedApps: FamilyActivitySelection
    var timeLimit: TimeInterval
    var unlocks: Int = 0
}
