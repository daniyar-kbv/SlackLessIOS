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
    func makeSelectAppsModule() -> (viewModel: SelectAppsViewModel, controller: SelectAppsController)
    func makeSelectPriceModule() -> (viewModel: SelectPriceViewModel, controller: SelectPriceController)
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
        let viewModel = RequestAuthViewModellImpl(screenTimeService: serviceFactory.makeScreenTimeService())
        return (viewModel, .init(viewModel: viewModel))
    }
    
    func makeSelectAppsModule() -> (viewModel: SelectAppsViewModel, controller: SelectAppsController) {
        let viewModel = SelectAppsViewModelImpl(screenTimeService: serviceFactory.makeScreenTimeService())
        return (viewModel, .init(viewModel: viewModel))
    }
    
    func makeSelectPriceModule() -> (viewModel: SelectPriceViewModel, controller: SelectPriceController) {
        let viewModel = SelectPriceViewModelImpl(appsSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel, .init(viewModel: viewModel))
    }
}
