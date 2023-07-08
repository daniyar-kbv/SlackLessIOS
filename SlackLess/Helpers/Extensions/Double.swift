//
//  Double.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import Foundation

extension Double {
    func getHours() -> Int {
        Int(self/3600)
    }
    
    func getRemainderMinutes() -> Int {
        Int((self/60).truncatingRemainder(dividingBy: 3600))
    }
}
