//
//  CustomizeViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import RxCocoa
import RxSwift

protocol CustomizeViewModelInput: AnyObject {}

protocol CustomizeViewModelOutput: AnyObject {
    var settingViewModel: SLSettingsViewModel { get }
}

protocol CustomizeViewModel: AnyObject {
    var input: CustomizeViewModelInput { get }
    var output: CustomizeViewModelOutput { get }
}

final class CustomizeViewModelImpl: CustomizeViewModel, CustomizeViewModelInput, CustomizeViewModelOutput {
    var input: CustomizeViewModelInput { self }
    var output: CustomizeViewModelOutput { self }

    private let appSettingsService: AppSettingsService

    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full,
                                                                             appSettingsService: appSettingsService)

//    Input
}
