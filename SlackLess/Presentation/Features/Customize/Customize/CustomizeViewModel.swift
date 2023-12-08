//
//  CustomizeViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import RxCocoa
import RxSwift

//  TODO: Update settings values when after set up

protocol CustomizeViewModelInput: AnyObject {
    func unlock()
    func showSetUp()
}

protocol CustomizeViewModelOutput: AnyObject {
    var settingViewModel: SLSettingsViewModel { get }
    var showUnlockButton: BehaviorRelay<Bool> { get }
    var startUnlock: PublishRelay<Void> { get }
    var startFeedback: PublishRelay<Void> { get }
    var startSetUp: PublishRelay<Void> { get }
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
        bindSettingsViewModel()
    }

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full,
                                                                             appSettingsService: appSettingsService,
                                                                             pushNotificationsService: pushNotificationsService)
    lazy var showUnlockButton: BehaviorRelay<Bool> = .init(value: appSettingsService.output.getIsLocked())
    let startUnlock: PublishRelay<Void> = .init()
    let startFeedback: PublishRelay<Void> = .init()
    let startSetUp: PublishRelay<Void> = .init()

//    Input
    func unlock() {
        startUnlock.accept(())
    }
    
    func showSetUp() {
        startSetUp.accept(())
    }
}

extension CustomizeViewModelImpl {
    private func bindService() {
        appSettingsService.output.isLocked
            .bind(to: showUnlockButton)
            .disposed(by: disposeBag)
    }
    
    private func bindSettingsViewModel() {
        settingViewModel.output.feedbackSelected
            .bind(to: startFeedback)
            .disposed(by: disposeBag)
    }
}
