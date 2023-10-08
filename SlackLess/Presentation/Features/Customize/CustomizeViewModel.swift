//
//  CustomizeViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import RxCocoa
import RxSwift

protocol CustomizeViewModelInput: AnyObject {
    func unlock()
}

protocol CustomizeViewModelOutput: AnyObject {
    var settingViewModel: SLSettingsViewModel { get }
    var showUnlockButton: BehaviorRelay<Bool> { get }
    var startUnlock: PublishRelay<Void> { get }
}

protocol CustomizeViewModel: AnyObject {
    var input: CustomizeViewModelInput { get }
    var output: CustomizeViewModelOutput { get }
}

final class CustomizeViewModelImpl: CustomizeViewModel, CustomizeViewModelInput, CustomizeViewModelOutput {
    var input: CustomizeViewModelInput { self }
    var output: CustomizeViewModelOutput { self }

    private let appSettingsService: AppSettingsService
    private let pushNotificationsService: PushNotificationsService

    private let disposeBag = DisposeBag()

    init(appSettingsService: AppSettingsService,
         pushNotificationsService: PushNotificationsService) {
        self.appSettingsService = appSettingsService
        self.pushNotificationsService = pushNotificationsService

        bindService()
    }

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full,
                                                                             appSettingsService: appSettingsService,
                                                                             pushNotificationsService: pushNotificationsService)
    lazy var showUnlockButton: BehaviorRelay<Bool> = .init(value: appSettingsService.output.getIsLocked())
    let startUnlock: PublishRelay<Void> = .init()

//    Input
    func unlock() {
        startUnlock.accept(())
    }
}

extension CustomizeViewModelImpl {
    private func bindService() {
        appSettingsService.output.isLocked
            .bind(to: showUnlockButton)
            .disposed(by: disposeBag)
    }
}
