//
//  OnboardingModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol OnboardingModulesFactory: AnyObject {
    func makeWelcomeScreenModule() -> (viewModel: WelcomeScreenViewModel, controller: WelcomeScreenController)
    func makeRequestAuthModule() -> (viewModel: RequestAuthViewModel, controller: RequestAuthController)
    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController)
}

final class OnboardingModulesFactoryImpl: OnboardingModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeWelcomeScreenModule() -> (viewModel: WelcomeScreenViewModel, controller: WelcomeScreenController) {
        let viewModel = WelcomeScreenViewModelImpl()
        return (viewModel, .init(viewModel: viewModel))
    }

    func makeRequestAuthModule() -> (viewModel: RequestAuthViewModel, controller: RequestAuthController) {
        let viewModel = RequestAuthViewModellImpl(appSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel, .init(viewModel: viewModel))
    }

    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController) {
        let viewModel = SetUpViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel, .init(viewModel: viewModel))
    }
}
