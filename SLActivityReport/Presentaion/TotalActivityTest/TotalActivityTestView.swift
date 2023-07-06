//
//  TotalActivityTestView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-04.
//

import Foundation
import SwiftUI

struct TotalActivityTestView: View {
    var activityReport: ActivityTestReport
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            Text("Total Screen Time")
            Spacer(minLength: 10)
            Text(activityReport.totalDuration.stringFromTimeInterval())
            List(activityReport.apps) { app in
                ListRow(eachApp: app)
            }
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceTestActivity
    var body: some View {
        HStack {
            Text(eachApp.displayName)
            Spacer()
            Text(eachApp.id)
            Spacer()
            Text("\(eachApp.numberOfPickups)")
            Spacer()
            Text(String(eachApp.duration.formatted()))
        }
    }
}
