//
//  SLAppsSelectionView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-22.
//

import FamilyControls
import Foundation
import SwiftUI

struct SLAppsSelectionView: View {
    @State var selection: FamilyActivitySelection
    @State var isPresented = false

    var onSelect: (FamilyActivitySelection) -> Void

    var body: some View {
        VStack {
            Button {
                isPresented = true
            } label: {
                Text("")
                    .frame(maxWidth: .infinity)
            }
            .familyActivityPicker(isPresented: $isPresented,
                                  selection: $selection)
        }
        .onChange(of: isPresented) { isPresented in
            if !isPresented {
                onSelect(selection)
            }
        }
    }
}
