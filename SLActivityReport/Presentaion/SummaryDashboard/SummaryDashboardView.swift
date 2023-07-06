//
//  SummaryDashboardView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-04.
//

import Foundation
import SwiftUI

struct SummaryDashboardView: View {
    let report: SummaryDashboardReport
    
    var body: some View {
        ZStack {
            GeometryReader { gr in
                SLColors.accent1.getSwiftUIColor()
                    .edgesIgnoringSafeArea(.all)
                SummaryDashboardCircularProgressView(progress: report.getPercentage())
                    .scaledToFill()
                    .padding(.top, 32)
                    .padding(.horizontal, 32)
                VStack(spacing: -8) {
                    Text(SLTexts.Summary.FirstContainer.title.localized())
                        .font(SLFonts.primary.getSwiftUIFont(ofSize: 17, weight: .bold))
                        .bold()
                        .foregroundStyle(SLColors.white.getSwiftUIColor())
                    Text(report.getFormattedSpentTime())
                        .font(SLFonts.primary.getSwiftUIFont(ofSize: 64, weight: .bold))
                        .bold()
                        .foregroundStyle(SLColors.white.getSwiftUIColor())
                    Text(SLTexts.Summary.FirstContainer.subtitle.localized(report.getFormattedTimeLimit()))
                        .font(SLFonts.primary.getSwiftUIFont(ofSize: 13, weight: .bold))
                        .bold()
                        .foregroundStyle(SLColors.white.getSwiftUIColor())
                }
                .position(x: gr.size.width/2,
                          y: (gr.size.height/2)+(((gr.size.height-((Constants.screenSize.width-64)/2)-32)/2))+32)
            }
        }
        .clipped()
    }
}
