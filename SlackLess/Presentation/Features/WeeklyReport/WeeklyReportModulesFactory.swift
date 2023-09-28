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
    private let appSettingsService: AppSettingsService

    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
    }

    func makeReportModule() -> (viewModel: ProgressViewModel, controller: ProgressController) {
        let viewModel = ProgressViewModelImpl(type: .weeklyReport, appSettingsService: appSettingsService)
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }

    func makeSetUpModule() -> (viewModel: SetUpViewModel, controller: SetUpController) {
        let viewModel = SetUpViewModelImpl(appSettingsService: appSettingsService)
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
