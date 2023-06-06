//
//  SummaryCoordinatorFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation

protocol SummaryModulesFactory: AnyObject {
    func makeSummaryModule() -> (viewModel: SummaryViewModel, controller: SummaryController)
}

final class SummaryModulesFactoryImpl: SummaryModulesFactory {
    func makeSummaryModule() -> (viewModel: SummaryViewModel, controller: SummaryController) {
        let viewModel = SummaryViewModelImpl()
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
