//
//  Tests.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import DeviceActivity
import FamilyControls
import Foundation
import ScreenTime

final class ExperimentManager {
    static let shared = ExperimentManager()
    
    private let screenTimeExperiments = ScreenTimeExperiments()
    
    func run() {
        screenTimeExperiments.run()
    }
}
