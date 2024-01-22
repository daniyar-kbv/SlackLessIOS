//
//  CustomizeModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation

protocol CustomizeModulesFactory: AnyObject {
    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController)
    func makeFeedbackModule() -> (viewModel: FeedbackViewModel, controller: FeedbackController)
    func makeTokensModule() -> (viewModel: TokensViewModel, controller: TokensController)
}

final class CustomizeModulesFactoryImpl: CustomizeModulesFactory {
    private let serviceFactory: ServiceFactory
    private let helpersFactory: HelpersFactory

    init(serviceFactory: ServiceFactory,
         helpersFactory: HelpersFactory) {
        self.serviceFactory = serviceFactory
        self.helpersFactory = helpersFactory
    }

    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController) {
        let viewModel = CustomizeViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                               pushNotificationsService: serviceFactory.makePushNotificationsService(),
                                               tokensService: serviceFactory.makeTokensService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
    
    func makeFeedbackModule() -> (viewModel: FeedbackViewModel, controller: FeedbackController) {
        let viewModel = FeedbackViewModelImpl(feedbackService: serviceFactory.makeFeedbackService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
    
    func makeTokensModule() -> (viewModel: TokensViewModel, controller: TokensController) {
        let viewModel = TokensViewModelImpl(tokensService: serviceFactory.makeTokensService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
