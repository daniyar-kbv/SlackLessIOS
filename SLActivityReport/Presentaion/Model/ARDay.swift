//
//  ARDay.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation

struct ARDay {
    let date: Date
    let time: ARTime
    let selectedApps: [ARApp]
    let otherApps: [ARApp]
}
