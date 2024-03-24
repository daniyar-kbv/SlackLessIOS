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
    func makeModifySettingsModule() -> (viewModel: SetUpViewModel, controller: SetUpController)
}

final class CustomizeModulesFactoryImpl: CustomizeModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController) {
        let viewModel = CustomizeViewModelImpl(lockService: serviceFactory.makeLockService(),
                                               pushNotificationsService: serviceFactory.makePushNotificationsService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
    
    func makeFeedbackModule() -> (viewModel: FeedbackViewModel, controller: FeedbackController) {
        let viewModel = FeedbackViewModelImpl(feedbackService: serviceFactory.makeFeedbackService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
    
    func makeModifySettingsModule() -> (viewModel: SetUpViewModel, controller: SetUpController) {
        let viewModel = SetUpViewModelImpl(lockService: serviceFactory.makeLockService(),
                                           state: .modify)
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
