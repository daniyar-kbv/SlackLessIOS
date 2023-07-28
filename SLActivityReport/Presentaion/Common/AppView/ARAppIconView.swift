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
    @State var imageSize: CGFloat = 0

    var body: some View {
        VStack {
            Label(applicationToken)
                .labelStyle(.iconOnly)
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                imageSize = geometry.size.width
                            }
                    }
                }
                .scaleEffect(28/imageSize)
        }
    }
}
