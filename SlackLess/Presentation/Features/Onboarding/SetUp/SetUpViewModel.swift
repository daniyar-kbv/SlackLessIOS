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
    func getState() -> SetUpView.State
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
    
    private let state: SetUpView.State

    init(appSettingsService: AppSettingsService,
         state: SetUpView.State) {
        self.appSettingsService = appSettingsService
        self.state = state
        
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
    
    func getState() -> SetUpView.State {
        return state
    }

    //    Input
    func save() {
        settingsViewModel.input.save()
    }
    
    func finish() {
        didFinish.accept(())
    }
}
