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
    func makeCustomizeModule() -> (viewModel: CustomizeViewModel, controller: CustomizeController) {
        let viewModel = CustomizeViewModelImpl()
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
