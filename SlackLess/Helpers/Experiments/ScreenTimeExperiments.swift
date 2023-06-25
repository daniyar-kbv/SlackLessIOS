//
//  ScreenTimeExperiments.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-10.
//

import Foundation
import FamilyControls
import DeviceActivity
import SwiftUI

final class ScreenTimeExperiments {
    func run() {
        UIApplication.shared.set(rootViewController: ScreenTimeExperimentsController())
//        requestAuthorization()
    }
    
    private func requestAuthorization() {
        let authorizationCenter = AuthorizationCenter.shared
        Task {
            try await authorizationCenter.requestAuthorization(for: .individual)
        }
    }
}
