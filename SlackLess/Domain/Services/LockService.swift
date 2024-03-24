//
//  LockService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import FamilyControls
import Foundation
import RxCocoa
import RxSwift

protocol LockServiceInput: AnyObject {
    func update(selectedApps: FamilyActivitySelection, timeLimit: TimeInterval)
}

protocol LockServiceOutput: AnyObject {
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var dayDataSaved: PublishRelay<Void> { get }
    
    func getCurrentTimeLimit() -> TimeInterval?
    func getCurrentSelectedApps() -> FamilyActivitySelection?
}

protocol LockService: AnyObject {
    var input: LockServiceInput { get }
    var output: LockServiceOutput { get }
}

final class LockServiceImpl: LockService, LockServiceInput, LockServiceOutput {
    var input: LockServiceInput { self }
    var output: LockServiceOutput { self }

    private let appSettingsRepository: AppSettingsRepository
    private let eventManager: EventManager
    private let deviceActivityCenter = DeviceActivityCenter()

    init(appSettingsRepository: AppSettingsRepository, eventManager: EventManager) {
        self.appSettingsRepository = appSettingsRepository
        self.eventManager = eventManager
    }

    //    Output
    let errorOccured: PublishRelay<ErrorPresentable> = .init()

    let dayDataSaved: PublishRelay<Void> = .init()
    
    func getCurrentTimeLimit() -> Double? {
        appSettingsRepository.output.getDayData(for: Date())?.timeLimit
    }

    func getCurrentSelectedApps() -> FamilyActivitySelection? {
        appSettingsRepository.output.getDayData(for: Date())?.selectedApps
    }

    //    Input
    func update(selectedApps: FamilyActivitySelection, timeLimit: TimeInterval) {
        let dayData = DayData(date: Date().getDate(),
                              selectedApps: selectedApps,
                              timeLimit: timeLimit)
        
        appSettingsRepository.input.set(dayData: dayData)
        appSettingsRepository.input.set(shield: nil)
        
        switch SLLocker.shared.updateLock(dayData: dayData) {
        case .success:
            dayDataSaved.accept(())
        case let .failed(error):
            errorOccured.accept(PresentationError.using(error))
        }
    }
}
