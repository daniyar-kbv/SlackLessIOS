//
//  SystemServiceFilter.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2024-01-07.
//

import Foundation
import DeviceActivity
import FamilyControls

/// Smart utility for filtering out system services from app activity data
struct SystemServiceFilter {
    
    /// Determines if an app is a legitimate user app using intelligent detection
    static func isUserApp(_ app: DeviceActivityData.ApplicationActivity, 
                         selectedApps: FamilyActivitySelection) -> Bool {
        guard let token = app.application.token else { return false }
        
        // Priority 1: User explicitly selected this app
        if selectedApps.applicationTokens.contains(token) {
            return true
        }
        
        // Priority 2: Check if this app belongs to a selected category
        // (This would require additional logic to map apps to categories)
        
        // Priority 3: Smart system service detection
        if isSystemService(app) {
            return false
        }
        
        // Priority 4: Include apps with valid user-facing characteristics
        return hasUserAppCharacteristics(app)
    }
    
    /// Intelligent system service detection based on characteristics
    private static func isSystemService(_ app: DeviceActivityData.ApplicationActivity) -> Bool {
        let bundleId = app.application.bundleIdentifier ?? ""
        let appName = app.application.localizedDisplayName ?? ""
        
        // Rule 1: Apple system bundle identifiers
        if bundleId.hasPrefix("com.apple.") {
            // But allow some legitimate Apple apps that users might actually use
            let allowedAppleApps = [
                "com.apple.mobilemail",      // Mail
                "com.apple.mobilesafari",    // Safari
                "com.apple.music",           // Music
                "com.apple.camera",          // Camera
                "com.apple.photos",          // Photos
                "com.apple.maps",            // Maps
                "com.apple.weather",         // Weather
                "com.apple.calculator",      // Calculator
                "com.apple.notes",           // Notes
                "com.apple.reminders",       // Reminders
                "com.apple.calendar",        // Calendar
                "com.apple.clock",           // Clock
                "com.apple.health",          // Health
                "com.apple.wallet",          // Wallet
                "com.apple.settings",        // Settings (user might want to track)
                "com.apple.appstore",        // App Store
                "com.apple.facetime",        // FaceTime
                "com.apple.messages",        // Messages
                "com.apple.phone"            // Phone
            ]
            
            if allowedAppleApps.contains(bundleId) {
                return false // This is a legitimate Apple app
            }
            
            return true // This is a system service
        }
        
        // Rule 2: System service naming patterns
        let systemKeywords = [
            "authentication", "auth", "security", "system", "framework", 
            "service", "daemon", "agent", "helper", "tool", "utility",
            "library", "component", "extension", "plugin", "process",
            "interface", "ui", "core", "private", "internal", "dt"
        ]
        
        let lowercasedName = appName.lowercased()
        let lowercasedBundle = bundleId.lowercased()
        
        for keyword in systemKeywords {
            if lowercasedName.contains(keyword) || lowercasedBundle.contains(keyword) {
                // But check if it's a legitimate app that happens to contain these words
                if !isLegitimateAppWithSystemKeywords(bundleId: bundleId, appName: appName) {
                    return true
                }
            }
        }
        
        // Rule 3: Empty or invalid identifiers
        if bundleId.isEmpty || appName.isEmpty {
            return true
        }
        
        // Rule 4: Generic system names
        let genericSystemNames = [
            "system", "system service", "system app", "system utility",
            "system tool", "system helper", "system agent", "system daemon"
        ]
        
        for genericName in genericSystemNames {
            if lowercasedName == genericName.lowercased() {
                return true
            }
        }
        
        return false
    }
    
    /// Check if an app with system-like keywords is actually a legitimate app
    private static func isLegitimateAppWithSystemKeywords(bundleId: String, appName: String) -> Bool {
        // These are legitimate apps that might contain system-like keywords
        let legitimateApps = [
            "com.apple.mobilemail",      // Mail (contains "mobile")
            "com.apple.mobilesafari",    // Safari (contains "mobile")
            "com.apple.music",           // Music
            "com.apple.camera",          // Camera
            "com.apple.photos",          // Photos
            "com.apple.maps",            // Maps
            "com.apple.weather",         // Weather
            "com.apple.calculator",      // Calculator
            "com.apple.notes",           // Notes
            "com.apple.reminders",       // Reminders
            "com.apple.calendar",        // Calendar
            "com.apple.clock",           // Clock
            "com.apple.health",          // Health
            "com.apple.wallet",          // Wallet
            "com.apple.settings",        // Settings
            "com.apple.appstore",        // App Store
            "com.apple.facetime",        // FaceTime
            "com.apple.messages",        // Messages
            "com.apple.phone"            // Phone
        ]
        
        return legitimateApps.contains(bundleId)
    }
    
    /// Check if an app has characteristics of a legitimate user app
    private static func hasUserAppCharacteristics(_ app: DeviceActivityData.ApplicationActivity) -> Bool {
        let bundleId = app.application.bundleIdentifier ?? ""
        let appName = app.application.localizedDisplayName ?? ""
        
        // Must have both bundle ID and name
        guard !bundleId.isEmpty && !appName.isEmpty else { return false }
        
        // Must not be Apple system services
        if bundleId.hasPrefix("com.apple.") {
            return false
        }
        
        // Must have a reasonable app name (not just generic terms)
        let genericTerms = ["app", "application", "service", "system", "utility", "tool"]
        let lowercasedName = appName.lowercased()
        
        for term in genericTerms {
            if lowercasedName == term {
                return false
            }
        }
        
        // Must have a reasonable bundle identifier format
        // User apps typically have reverse domain notation
        if !bundleId.contains(".") || bundleId.count < 5 {
            return false
        }
        
        return true
    }
} 