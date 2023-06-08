//
//  AppInfo.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-07.
//

import Foundation

struct AppInfo {
    let name: String
    let image: Data
    let time: Int
}

extension AppInfo {
    func toUI() -> AppInfoUI {
        .init(name: name,
              image: .init(data: image),
              time: time)
    }
}
