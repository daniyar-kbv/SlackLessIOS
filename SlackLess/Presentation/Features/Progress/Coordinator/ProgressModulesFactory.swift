//
//  ProgressModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation

protocol ProgressModulesFactory: AnyObject {
    func makeProgressModule() -> (viewModel: ProgressViewModel, controller: ProgressController)
}

final class ProgressModulesFactoryImpl: ProgressModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeProgressModule() -> (viewModel: ProgressViewModel, controller: ProgressController) {
        let viewModel = ProgressViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
