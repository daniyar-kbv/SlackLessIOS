//
//  DateInterval.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-13.
//

import Foundation

extension DateInterval {
    func containsDate(_ date: Date) -> Bool {
        guard date != end else { return false }
        return contains(date)
    }
}
