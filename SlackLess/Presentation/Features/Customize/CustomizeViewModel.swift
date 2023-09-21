//
//  CustomizeViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation

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

//    Output
    lazy var settingViewModel: SLSettingsViewModel = SLSettingsViewModelImpl(type: .full)

//    Input
}
