//
//  ScreenTimeExperiments.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-10.
//

import Foundation
import FamilyControls
import DeviceActivity

final class ScreenTimeExperiments {
    func run() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        let authorizationCenter = AuthorizationCenter.shared
        Task {
            try await authorizationCenter.requestAuthorization(for: .individual)
        }
    }
    
    private func test() {
        
    }
}
