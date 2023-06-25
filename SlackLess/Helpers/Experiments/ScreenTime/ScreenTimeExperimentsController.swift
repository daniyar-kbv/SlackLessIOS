//
//  ExperimentsController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-19.
//

import Combine
import UIKit
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

class ScreenTimeExperimentsController: UIViewController {
    private var hostingController: UIViewController?
    private let state = SLViewState()
    private var cancellables = Set<AnyCancellable>()
    let store = ManagedSettingsStore(named: .selectedApps)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView = ScreenTimeExperimentsView(state: state, model: ScreenTimeSelectAppsModel.shared)
        
        let controller = UIHostingController(rootView: rootView)
        hostingController = controller
        addChild(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.didMove(toParent: self)
        
        ScreenTimeSelectAppsModel.shared.$activitySelection.sink { selection in
            self.saveSelection(selection: selection)
            self.store.shield.applications = selection
                .applicationTokens
        }
        .store(in: &cancellables)
        
//        let schedule = DeviceActivitySchedule(
//            // I've set my schedule to start and end at midnight
//            intervalStart: DateComponents(hour: 0, minute: 0),
//            intervalEnd: DateComponents(hour: 23, minute: 50),
//            // I've also set the schedule to repeat
//            repeats: true
//        )
//        
//        let center = DeviceActivityCenter()
//        do {
//            try center.startMonitoring(.daily, during: schedule)
//        } catch { }
    }
    
    func saveSelection(selection: FamilyActivitySelection) {
        guard let defaults = UserDefaults(suiteName: "group.kz.slackless") else { return }
        let encoder = PropertyListEncoder()
        let userDefaultsKey = "ScreenTimeSelection"

        defaults.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
        
        guard let data = defaults.data(forKey: userDefaultsKey) else { return }
        let decoder = PropertyListDecoder()
        let decoded = try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )
//        print(decoded)
    }
}

public class ScreenTimeSelectAppsModel: ObservableObject {
    @Published var activitySelection = FamilyActivitySelection()
    
    static let shared = ScreenTimeSelectAppsModel()

    init() { }
}

extension DeviceActivityName {
    // Set the name of the activity to "daily"
    static let daily = Self("daily")
}

extension ManagedSettingsStore.Name {
    static let selectedApps = Self("selectedApps")
}
