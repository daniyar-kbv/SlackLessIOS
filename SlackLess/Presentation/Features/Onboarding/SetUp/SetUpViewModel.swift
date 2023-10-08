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
    func save()
    func finish()
}

protocol SetUpViewModelOutput: AnyObject {
    var isComplete: BehaviorRelay<Bool> { get }
    var didSave: PublishRelay<Void> { get }
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
    private let settingsViewModel: SLSettingsViewModel

    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
        
        settingsViewModel = SLSettingsViewModelImpl(type: .setUp,
                                                    appSettingsService: appSettingsService,
                                                    pushNotificationsService: nil)
        didSave = settingsViewModel.output.didSave
        isComplete = settingsViewModel.output.isComplete
    }

    //    Output
    let didSave: PublishRelay<Void>
    let isComplete: BehaviorRelay<Bool>
    let didFinish: PublishRelay<Void> = .init()

    func getSettingsViewModel() -> SLSettingsViewModel {
        settingsViewModel
    }

    //    Input
    func save() {
        settingsViewModel.input.save()
    }
    
    func finish() {
        didFinish.accept(())
    }
}
