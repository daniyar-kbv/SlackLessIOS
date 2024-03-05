//
//  WeeklyReportModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-26.
//

import Foundation

protocol WeeklyReportModulesFactory: AnyObject {
    func makeReportModule() -> (viewModel: ProgressViewModel, controller: ProgressController)
    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController)
}

final class WeeklyReportModulesFactoryImpl: WeeklyReportModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeReportModule() -> (viewModel: ProgressViewModel, controller: ProgressController) {
        let viewModel = ProgressViewModelImpl(type: .weeklyReport,
                                              appSettingsService: serviceFactory.makeAppSettingsService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }

    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController) {
        let viewModel = SetUpViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                           state: .adjust)
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
