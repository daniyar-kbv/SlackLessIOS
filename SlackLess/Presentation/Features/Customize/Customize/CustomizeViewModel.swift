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
    func showSetUp()
}

protocol CustomizeViewModelOutput: AnyObject {
    var settingViewModel: SLSettingsViewModel { get }
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

        bindSettingsViewModel()
    }

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full,
                                                                             appSettingsService: appSettingsService,
                                                                             pushNotificationsService: pushNotificationsService)
    let startFeedback: PublishRelay<Void> = .init()
    let startSetUp: PublishRelay<Void> = .init()

//    Input
    func showSetUp() {
        startSetUp.accept(())
    }
}

extension CustomizeViewModelImpl {
    private func bindSettingsViewModel() {
        settingViewModel.output.feedbackSelected
            .bind(to: startFeedback)
            .disposed(by: disposeBag)
    }
}
