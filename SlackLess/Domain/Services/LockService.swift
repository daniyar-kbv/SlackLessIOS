//
//  LockService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift

protocol LockServiceInput: AnyObject {
    func updateLock(type: SLLockUpdateType)
}

protocol LockServiceOutput: AnyObject {
    var didUpdateLock: PublishRelay<SLLockUpdateType> { get }
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
    let didUpdateLock: PublishRelay<SLLockUpdateType> = .init()

    //    Input
    func updateLock(type: SLLockUpdateType) {
        let date = Date().getDate()

        guard let selection = appSettingsRepository.output.getSelectedApps(for: date)
        else {
            eventManager.send(event: .init(type: .updateLockFailed, value: DomainError.updateLockFailed))
            return
        }
        let limit = appSettingsRepository.output.getTimeLimit(for: date)
        let unlockedTime = appSettingsRepository.output.getUnlockedTime(for: date)
        let unlockTime = unlockedTime + type.unlockTime
        let newLimit = limit + unlockTime

        deviceActivityCenter.stopMonitoring()

        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(second: Int(newLimit))
        )

        do {
            try deviceActivityCenter.startMonitoring(
                .daily,
                during: Constants.DeviceActivity.schedule,
                events: [
                    .limitReached: event,
                ]
            )

            appSettingsRepository.input.set(unlockedTime: unlockTime, for: date)
            eventManager.send(event: .init(type: .updateLockSucceed, value: type))
            didUpdateLock.accept(type)
        } catch {
            print(error)
            eventManager.send(event: .init(type: .updateLockFailed, value: error))
        }
    }
}

extension LockServiceImpl {
    private func bindEventManager() {
        eventManager.subscribe(to: .appLimitSettingsChanged, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLock(type: .refresh)
        }

        eventManager.subscribe(to: .paymentFinished, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLock(type: .longUnlock)
        }
    }
}
