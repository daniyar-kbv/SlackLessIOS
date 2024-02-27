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
    func updateLock()
}

protocol LockServiceOutput: AnyObject {
    
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
    private let disposeBag = DisposeBag()
    private let deviceActivityCenter = DeviceActivityCenter()

    init(appSettingsRepository: AppSettingsRepository, eventManager: EventManager) {
        self.appSettingsRepository = appSettingsRepository
        self.eventManager = eventManager

        bindEventManager()
    }

    //    Output

    //    Input
    func updateLock() {
//        TODO: Refactor to use getDate only in Data Layer
        let date = Date().getDate()

//        TODO: Refactor to optimize fetching DayData
        guard let dayData = appSettingsRepository.output.getDayData(for: date)
        else {
            eventManager.send(event: .init(type: .updateLockFailed, value: DomainError.updateLockFailed))
            return
        }
        
        switch SLLocker.shared.updateLock(dayData: dayData) {
        case .success: break
        case let .failed(error): eventManager.send(event: .init(type: .updateLockFailed, value: error))
        }
    }
}

extension LockServiceImpl {
    private func bindEventManager() {
        eventManager.subscribe(to: .appLimitSettingsChanged, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLock()
        }
    }
}
