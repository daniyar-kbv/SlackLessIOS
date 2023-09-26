//
//  DeviceActivityMonitorExtension.swift
//  SLActivityMonitor
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import Foundation
import ManagedSettings

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    private let dataComponentsFactory: DataComponentsFactory = DataComponenetsFactoryImpl()
    private lazy var appSettingsRepository = dataComponentsFactory
        .makeRepositoryFactory()
        .makeAppSettingsRepository()
    private let store = ManagedSettingsStore()

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        store.shield.applications = nil
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)

        guard let selection = appSettingsRepository.output.getSelectedApps(for: Date().getDate())
        else { return }

        store.shield.applications = selection.applicationTokens
    }
}
