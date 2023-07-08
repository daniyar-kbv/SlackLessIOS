//
//  App.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-06.
//

import Foundation
import SwiftUI

struct SLApp {
    let icon: Image?
    let name: String?
    let time: Double
    let percentage: Double
    
    func getFormattedTime() -> String {
        var string = time.getHours() == 0 ? "" : "\(time.getHours()) "
        return (time.getRemainderMinutes()<10 ? "0" : "") + "\(time.getRemainderMinutes()) min"
    }
}
