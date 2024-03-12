//
//  OnboardingModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol OnboardingModulesFactory: AnyObject {
    func makeWelcomeScreenModule() -> (viewModel: WelcomeScreenViewModel, controller: WelcomeScreenController)
    func makeSurveyModule(for question: SurveyQuestion) -> (viewModel: SurveyViewModel, controller: SurveyController)
    func makeCalculationController() -> CalculationController
    func makeResultsModule() -> (viewModel: ResultsViewModel, controller: ResultsController)
    func makeRequestAuthModule() -> (viewModel: RequestAuthViewModel, controller: RequestAuthController)
    func makeIntroductionModule() -> (viewModel: IntroductionViewModel, controller: IntroductionController)
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
    
    func makeSurveyModule(for question: SurveyQuestion) -> (viewModel: SurveyViewModel, controller: SurveyController) {
        let viewModel = SurveyViewModelImpl(onboardingService: serviceFactory.makeOnboardingService(),
                                            question: question)
        return (viewModel, .init(viewModel: viewModel))
    }
    
    func makeCalculationController() -> CalculationController {
        return .init()
    }
    
    func makeResultsModule() -> (viewModel: ResultsViewModel, controller: ResultsController) {
        let viewModel = ResultsViewModelImpl(onboardingService: serviceFactory.makeOnboardingService())
        return (viewModel, .init(viewModel: viewModel))
    }

    func makeRequestAuthModule() -> (viewModel: RequestAuthViewModel, controller: RequestAuthController) {
        let viewModel = RequestAuthViewModellImpl(onboardingService: serviceFactory.makeOnboardingService())
        return (viewModel, .init(viewModel: viewModel))
    }
    
    func makeIntroductionModule() -> (viewModel: IntroductionViewModel, controller: IntroductionController) {
        let viewModel = IntroductionViewModelImpl()
        return (viewModel, .init(viewModel: viewModel))
    }

    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController) {
        let viewModel = SetUpViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                           state: .setUp)
        return (viewModel, .init(viewModel: viewModel))
    }
}
