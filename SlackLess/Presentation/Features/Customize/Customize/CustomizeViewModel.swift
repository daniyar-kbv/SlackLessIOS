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
}

protocol CustomizeViewModelOutput: AnyObject {
    var settingViewModel: SLSettingsViewModel { get }
    var startFeedback: PublishRelay<Void> { get }
    var startModifySettings: PublishRelay<Void> { get }
}

protocol CustomizeViewModel: AnyObject {
    var input: CustomizeViewModelInput { get }
    var output: CustomizeViewModelOutput { get }
}

final class CustomizeViewModelImpl: CustomizeViewModel, CustomizeViewModelInput, CustomizeViewModelOutput {
    var input: CustomizeViewModelInput { self }
    var output: CustomizeViewModelOutput { self }

    private let lockService: LockService
    private let pushNotificationsService: PushNotificationsService

    private let disposeBag = DisposeBag()

    init(lockService: LockService,
         pushNotificationsService: PushNotificationsService) {
        self.lockService = lockService
        self.pushNotificationsService = pushNotificationsService

        bindSettingsViewModel()
    }

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full,
                                                                             lockService: lockService,
                                                                             pushNotificationsService: pushNotificationsService)
    let startFeedback: PublishRelay<Void> = .init()
    let startModifySettings: PublishRelay<Void> = .init()
    

//    Input
}

extension CustomizeViewModelImpl {
    private func bindSettingsViewModel() {
        settingViewModel.output.feedbackSelected
            .bind(to: startFeedback)
            .disposed(by: disposeBag)
        
        settingViewModel.output.startModifySettings
            .bind(to: startModifySettings)
            .disposed(by: disposeBag)
    }
}
