//
//  ShieldSettingsExtenstion.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-23.
//

import Foundation
import FamilyControls
import ManagedSettings

extension ShieldSettings {
    mutating func set(familyActivitySelection: FamilyActivitySelection) {
        applications = familyActivitySelection.applicationTokens
        applicationCategories = .specific(familyActivitySelection.categoryTokens)
    }
    
    mutating func reset() {
        applications = nil
        applicationCategories = nil
    }
}
