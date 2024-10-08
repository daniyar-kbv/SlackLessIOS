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

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        store.shield.reset()
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        store.shield.reset()
    }

    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        guard let shield = event.decode(),
              let dayData = repository.getDayData(for: Date().getDate())
        else { return }
        
        repository.set(shield: shield)
        store.shield.set(familyActivitySelection: dayData.selectedApps)
    }
}
