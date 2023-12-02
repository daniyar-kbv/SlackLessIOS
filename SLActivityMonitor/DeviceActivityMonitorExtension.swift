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
    private let dataComponentsFactory: DataComponentsFactory = DataComponentsFactoryImpl()
    private lazy var repository: Repository = dataComponentsFactory.makeRepository()
    private let store = ManagedSettingsStore()

    override func intervalDidStart(for _: DeviceActivityName) {
        repository.set(isLocked: false)
        repository.set(shieldState: .normal)
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)

        store.shield.applications = nil
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)

        guard let selection = repository.getSelectedApps(for: Date().getDate())
        else { return }

        store.shield.applications = selection.applicationTokens
        repository.set(isLocked: true)
    }
}
