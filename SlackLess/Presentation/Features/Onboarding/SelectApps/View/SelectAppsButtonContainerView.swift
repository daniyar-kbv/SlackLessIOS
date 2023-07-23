//
//  SelectAppsView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import SwiftUI
import FamilyControls

struct SelectAppsButtonContainerView: View {
    var onSelect: (FamilyActivitySelection)->()
    
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
            if !$0 && (!selection.applicationTokens.isEmpty || (!selection.categoryTokens.isEmpty)) {
                onSelect(selection)
            }
        }
    }
}

