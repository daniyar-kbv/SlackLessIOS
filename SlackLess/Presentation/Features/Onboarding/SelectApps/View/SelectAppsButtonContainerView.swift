//
//  SelectAppsButtonContainerView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import FamilyControls
import Foundation
import SwiftUI

struct SelectAppsButtonContainerView: View {
    var onSelect: (FamilyActivitySelection) -> Void

    @State var selection = FamilyActivitySelection()
    @State var isPresented = false

    var body: some View {
        VStack {
            SelectAppsButtonView {
                isPresented = true
            }
            .familyActivityPicker(isPresented: $isPresented,
                                  selection: $selection)
        }
        .onChange(of: isPresented) {
            if (Constants.appMode == .debug && !$0 && (!selection.applicationTokens.isEmpty || (!selection.categoryTokens.isEmpty))) || Constants.appMode == .debug {
                onSelect(selection)
            }
        }
    }
}
