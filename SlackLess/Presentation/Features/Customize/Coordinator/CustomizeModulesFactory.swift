//
//  CustomizeModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation

protocol CustomizeModulesFactory: AnyObject {
    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController)
}

final class CustomizeModulesFactoryImpl: CustomizeModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController) {
        let viewModel = CustomizeViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                               pushNotificationsService: serviceFactory.makePushNotificationsService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
