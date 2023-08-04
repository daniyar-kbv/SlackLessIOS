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
//            Label(applicationToken)
//                .labelStyle(AppIconLabelStyle())
//                .labelStyle(.iconOnly)
//                .background {
//                    GeometryReader { geometry in
//                        Color.clear
//                            .onAppear {
//                                imageSize = geometry.size.width
//                            }
//                    }
//                }
//                .scaleEffect(28/imageSize)

            Image(uiImage: SLImages.Common.appIconPlaceholder.getImage()!)
                .resizable()
                .frame(width: 28, height: 28)
                .cornerRadius(4)
        }
    }
}

struct AppIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.icon
                .frame(width: 28, height: 28)
        }
    }
}
