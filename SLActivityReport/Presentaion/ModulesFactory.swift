//
//  ModulesFactory.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-07.
//

import Foundation

protocol ControllersFactory: AnyObject {
    func makeSummaryController() -> SummaryInnerController
}

final class ControllersFactoryImpl: ControllersFactory {
    func makeSummaryController() -> SummaryInnerController {
        .init(viewModel: SummaryViewModelImpl())
    }
}
