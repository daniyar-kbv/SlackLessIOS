//
//  SummaryDashboardCircularProgressView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-04.
//

import Foundation
import SwiftUI

struct SummaryDashboardCircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(
                    SLColors.background1.getSwiftUIColor(),
                    lineWidth: 32
                )
                .rotationEffect(.init(degrees: -180))
            Circle()
                .trim(from: 0, to: (progress*0.5))
                .stroke(
                    SLColors.accent2.getSwiftUIColor(),
                    style: StrokeStyle(
                        lineWidth: 32,
                        lineCap: .round
                    )
                )
                .rotationEffect(.init(degrees: -180))
        }
    }
}
