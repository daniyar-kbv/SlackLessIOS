//
//  ARAppIconView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-24.
//

import Foundation
import SwiftUI
import ManagedSettings

struct ARAppIconView: View {
    @State var applicationToken: ApplicationToken
    
    var body: some View {
        VStack {
            Label(applicationToken)
                .labelStyle(.iconOnly)
                .scaleEffect(56/76)
        }
    }
}
