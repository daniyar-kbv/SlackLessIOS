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

protocol LockServiceInput: AnyObject {}

protocol LockServiceOutput: AnyObject {}

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
}

extension LockServiceImpl {
    private func bindEventManager() {
        eventManager.subscribe(to: .appLimitSettingsChanged, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLimits()
        }

        eventManager.subscribe(to: .paymentFinished, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLimits(unlockTime: Constants.Settings.unlockTime)
        }
    }

    private func updateLimits(unlockTime: TimeInterval = 0) {
        let date = Date().getDate()

        guard let selection = appSettingsRepository.output.getSelectedApps(for: date),
              let limit = appSettingsRepository.output.getTimeLimit(for: date)
        else {
            eventManager.send(event: .init(type: .updateLimitsFailed, value: DomainError.updateLimitsFailed))
            return
        }
        let unlockedTime = appSettingsRepository.output.getUnlockedTime(for: date)
        var newLimit = limit + unlockedTime + unlockTime

        deviceActivityCenter.stopMonitoring()

        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: DateComponents(second: Int(limit))
        )

        do {
            try deviceActivityCenter.startMonitoring(
                .daily,
                during: Constants.DeviceActivity.schedule,
                events: [
                    .limitReached: event,
                ]
            )

            appSettingsRepository.input.set(unlockedTime: unlockedTime + unlockTime, for: date)
            eventManager.send(event: .init(type: .updateLimitsSucceed))
        } catch {
            print(error)
            eventManager.send(event: .init(type: .updateLimitsFailed, value: error))
        }
    }
}
