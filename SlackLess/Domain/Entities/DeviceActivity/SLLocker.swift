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
    
    func updateLock(dayData: DayData, unlockedTime: TimeInterval) -> LockingResult {
            let familyActivitySelection = dayData.selectedApps
            let timeLimit = dayData.timeLimit

            var events: [(type: DeviceActivityEvent.Name, event: DeviceActivityEvent)] = calculateThresholds(for: timeLimit)
                .map({(
                    type: .encode(from: .init(type: .remind, threshold: $0)),
                    event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int($0)))
                )})
        
            let delayedLockThreshold = timeLimit + unlockedTime
        
            events.append((
                type: .encode(from: .init(type: .lock, threshold: delayedLockThreshold)),
                event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int(delayedLockThreshold)))
            ))
        
            let eventsDict = Dictionary(uniqueKeysWithValues: events.map({ ($0.type, $0.event) }))

            do {
                deviceActivityCenter.stopMonitoring()

                try deviceActivityCenter.startMonitoring(
                    .daily,
                    during: .init(
                        intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
                        intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                        repeats: true
                    ),
                    events: eventsDict
                )
                
                return .success
            } catch {
                print(error)
                return .failed(error: error)
            }
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
