//
//  UnlockModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-29.
//

import Foundation

protocol UnlockModulesFactory: AnyObject {
    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: UnlockController)
}

final class UnlockModulesFactoryImpl: UnlockModulesFactory {
    private let paymentService: PaymentService

    init(paymentService: PaymentService) {
        self.paymentService = paymentService
    }

    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: UnlockController) {
        let viewModel = UnlockViewModelImpl(paymentService: paymentService)
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
