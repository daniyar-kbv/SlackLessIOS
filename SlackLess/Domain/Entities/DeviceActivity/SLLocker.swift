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
    
    let unlockTime: TimeInterval = 600 // 10 minutes
    
    private init() {}
    
    func updateLock(dayData: DayData, delay: TimeInterval? = nil) -> LockingResult {
            let familyActivitySelection = dayData.selectedApps
            let timeLimit = dayData.timeLimit

            var events: [(type: DeviceActivityEvent.Name, event: DeviceActivityEvent)] = calculateThresholds(for: timeLimit)
                .map({(
                    type: .encode(type: .annoy, threshold: $0),
                    event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int($0)))
                )})
            events.append((
                type: .encode(type: .lock, threshold: timeLimit+(delay ?? 0)),
                event: makeDeviceActivityEvent(familyActivitySelection: familyActivitySelection, threshold: .init(second: Int(timeLimit)))
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
        let fixedCheckpoints: [TimeInterval] = [1, 2].map({ $0 * 60 })
        var thresholds = [TimeInterval]()
        
        for (index, fixedCheckpoint) in fixedCheckpoints.enumerated() {
            guard timeLimit > fixedCheckpoint else { break }
            
            let totalCheckpoints = fixedCheckpoints.enumerated().filter({ $0.offset <= index }).reduce(0, { $0 + $1.element })
            
            if index < fixedCheckpoints.count - 1 {
                thresholds.append(timeLimit-totalCheckpoints)
            } else {
                var totalTime = totalCheckpoints
                
                while totalTime < timeLimit {
                    thresholds.append(timeLimit-totalTime)
                    totalTime += 3600 // 1 hour
                }
            }
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
