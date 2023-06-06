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

final class Tester {
    func runTests() {
        authorizeFamilyControls { [weak self] in
            self?.testScreenTime()
        }
    }

    private func authorizeFamilyControls(completionHandler: @escaping (() -> Void)) {
        let authorizationCenter = AuthorizationCenter.shared
        let deniedText = "Family Controlls access denied"
        switch authorizationCenter.authorizationStatus {
        case .approved: completionHandler()
        default: requestAccess()
        }

        func requestAccess() {
            authorizationCenter.requestAuthorization {
                switch $0 {
                case .success(): completionHandler()
                default: print(deniedText)
                }
            }
        }
    }

    private func testScreenTime() {}
}
