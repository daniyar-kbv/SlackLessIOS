//
//  BundleExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-23.
//

import Foundation

//  TODO: Rename extensions

extension Bundle {
    var version: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var build: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
