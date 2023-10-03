//
//  SetUpViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-22.
//

import Foundation
import RxCocoa
import RxSwift

protocol SetUpViewModelInput: AnyObject {
    func finish()
}

protocol SetUpViewModelOutput: AnyObject {
    var didFinish: PublishRelay<Void> { get }

    func getSettingsViewModel() -> SLSettingsViewModel
}

protocol SetUpViewModel: AnyObject {
    var input: SetUpViewModelInput { get }
    var output: SetUpViewModelOutput { get }
}

final class SetUpViewModelImpl: SetUpViewModel, SetUpViewModelInput, SetUpViewModelOutput {
    var input: SetUpViewModelInput { self }
    var output: SetUpViewModelOutput { self }

    private let appSettingsService: AppSettingsService
    private lazy var settingsViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .setUp, appSettingsService: appSettingsService)

    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }

    //    Output
    var didFinish: PublishRelay<Void> = .init()

    func getSettingsViewModel() -> SLSettingsViewModel {
        settingsViewModel
    }

    //    Input
    func finish() {
        didFinish.accept(())
    }
}
