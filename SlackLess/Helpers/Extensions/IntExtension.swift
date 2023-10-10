//
//  Double.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import Foundation

extension Int {
    func getHours() -> Int {
        Int(self/3600)
    }
    
    func getRemaindingMinutes() -> Int {
        (self%3600)/60
    }
}
