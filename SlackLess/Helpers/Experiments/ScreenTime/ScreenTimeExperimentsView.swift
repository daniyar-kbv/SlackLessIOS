//
//  ScreenTimeExperimentsView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-19.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct ScreenTimeExperimentsView: View {
    let center = AuthorizationCenter.shared
    @ObservedObject var state: SLViewState
    @ObservedObject var model: ScreenTimeSelectAppsModel
    
    var body: some View {
        VStack {
            switch state.state {
            case .select: SelectView(state: state, model: model)
            case .auth: STProgressView()
            case .chart: ChartView()
            }
        }.onAppear {
            switch state.state {
            case .auth:
                Task {
                    do {
                        try await center.requestAuthorization(for: FamilyControlsMember.individual)
                        state.state = .select
                    } catch {
                        // Handle the error here.
                    }
                }
            default: break
            }
        }
    }
}

class SLViewState: ObservableObject {
    @Published var isPresented = true {
        didSet {
            if !isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                    self.state = .chart
                }
            }
        }
    }
    @Published var state: SLState = .chart

    init() { }
    
    enum SLState {
        case auth
        case select
        case chart
    }
}

struct SelectView: View {
    @ObservedObject var state: SLViewState
    @ObservedObject var model: ScreenTimeSelectAppsModel
    
    var body: some View {
        Button {

        } label: {
            Text("Select Apps")
        }
        .familyActivityPicker(
            isPresented: $state.isPresented,
            selection: $model.activitySelection
        )
    }
}

struct STProgressView: View {
    var body: some View {
        ProgressView {
            Text("Loading")
        }
    }
}

struct ChartView: View {
    @State private var context: DeviceActivityReport.Context = .init(rawValue: "Total Activity")
    @State private var filter = DeviceActivityFilter(
        segment: .daily(
            during: Calendar.current.dateInterval(
               of: .day, for: .now
            )!
        ),
        users: .all,
        devices: .init([.iPhone, .iPad])
    )

    var body: some View {
        ZStack {
            DeviceActivityReport(.init(Constants.ContextName.summary), filter: Constants.DeviceActivityFilters.summary)
        }
    }
}
