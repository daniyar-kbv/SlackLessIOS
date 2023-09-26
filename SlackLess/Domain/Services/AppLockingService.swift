//
//  AppLockingService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-24.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift

protocol AppLockingServiceInput: AnyObject {}

protocol AppLockingServiceOutput: AnyObject {}

protocol AppLockingService: AnyObject {
    var input: AppLockingServiceInput { get }
    var output: AppLockingServiceOutput { get }
}

final class AppLockingServiceImpl: AppLockingService, AppLockingServiceInput, AppLockingServiceOutput {
    var input: AppLockingServiceInput { self }
    var output: AppLockingServiceOutput { self }

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

extension AppLockingServiceImpl {
    private func bindEventManager() {
        eventManager.subscribe(to: .appLimitSettingsChanged, disposeBag: disposeBag) { [weak self] _ in
            self?.updateLockingEvent()
        }
    }

    private func updateLockingEvent() {
        let date = Date().getDate()

        guard let selection = appSettingsRepository.output.getSelectedApps(for: date),
              let limit = appSettingsRepository.output.getTimeLimit(for: date)
        else { return }

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
        } catch {
            print(error)
        }
    }
}
