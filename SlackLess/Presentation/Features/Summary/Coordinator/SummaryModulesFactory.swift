//
//  SummaryModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import Foundation

protocol SummaryModulesFactory: AnyObject {
    func makeSummaryModule() -> (viewModel: SummaryViewModel, controller: SummaryController)
}

final class SummaryModulesFactoryImpl: SummaryModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeSummaryModule() -> (viewModel: SummaryViewModel, controller: SummaryController) {
        let viewModel = SummaryViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
