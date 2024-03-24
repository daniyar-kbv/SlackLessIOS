//
//  SLLocker.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-02-14.
//

import Foundation
import DeviceActivity
import FamilyControls

struct SLLocker {
    static let shared = SLLocker()
    
    private let deviceActivityCenter = DeviceActivityCenter()
    
    private init() {}
    
    func updateLock(dayData: DayData) -> LockingResult {
        do {
            try deviceActivityCenter.startMonitoring(
                .daily,
                during: .init(
                    intervalStart: .init(hour: 0, minute: 0, second: 0),
                    intervalEnd: .init(hour: 23, minute: 59, second: 59),
                    repeats: true
                ),
                events: makeEvents(with: dayData)
            )
            
            return .success
        } catch {
            print(error)
            return .failed(error: error)
        }
    }
    
    private func makeEvents(with dayData: DayData) -> [DeviceActivityEvent.Name : DeviceActivityEvent] {
        let familyActivitySelection = dayData.selectedApps
        let timeLimit = dayData.timeLimit
        var events = [(type: DeviceActivityEvent.Name, event: DeviceActivityEvent)]()
        
        if dayData.unlocks == 0 {
            events.append(contentsOf: calculateThresholds(for: timeLimit)
                .map({(
                    type: .encode(from: .init(type: .remind, threshold: $0)),
                    event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int($0)))
                )}))
            
            events.append((
                type: .encode(from: .init(type: .lock, threshold: timeLimit)),
                event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int(timeLimit)))
            ))
        } else {
            let threshold = TimeInterval(Constants.Settings.unlockMinutes * 60)
            events.append((
                type: .encode(from: .init(type: .lock, threshold: threshold)),
                event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int(threshold)))
            ))
        }
        
        return Dictionary(uniqueKeysWithValues: events.reversed().map({ ($0.type, $0.event) }))
    }
    
    private func calculateThresholds(for timeLimit: TimeInterval) -> [TimeInterval] {
        let fixedCheckpoints: [TimeInterval] = [5, 10, 15, 30, 45].map({ $0 * 60 })
        var thresholds = fixedCheckpoints
            .filter({ timeLimit > $0 })
            .map({ timeLimit - $0 })
        
        var hourlyCheckpoint: TimeInterval = 3600
        
        while timeLimit > hourlyCheckpoint {
            thresholds.append(timeLimit-hourlyCheckpoint)
            hourlyCheckpoint += 3600 // + 1 hour
        }
        
        return thresholds
    }
    
    private func makeDeviceActivityEvent(familyActivitySelection: FamilyActivitySelection,
                                         threshold: DateComponents) -> DeviceActivityEvent {
        DeviceActivityEvent(
            applications: familyActivitySelection.applicationTokens,
            categories: familyActivitySelection.categoryTokens,
            threshold: threshold
        )
    }
}

extension SLLocker {
    enum LockingResult {
        case success
        case failed(error: Error)
    }
}
