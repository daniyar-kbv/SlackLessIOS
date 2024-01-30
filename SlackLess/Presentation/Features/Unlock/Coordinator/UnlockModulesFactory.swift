//
//  UnlockModulesFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-29.
//

import Foundation
import FittedSheets

protocol UnlockModulesFactory: AnyObject {
    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: SheetViewController)
    func makeTokensModule() -> (viewModel: TokensViewModel, controller: TokensController)
}

final class UnlockModulesFactoryImpl: UnlockModulesFactory {
    private let serviceFactory: ServiceFactory
    private let helpersFactory: HelpersFactory
    
    init(serviceFactory: ServiceFactory,
         helpersFactory: HelpersFactory) {
        self.serviceFactory = serviceFactory
        self.helpersFactory = helpersFactory
    }

    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: SheetViewController) {
        let viewModel = UnlockViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                            paymentService: serviceFactory.makePaymentService(),
                                            lockService: serviceFactory.makeLockService(),
                                            tokensService: serviceFactory.makeTokensService())
        let unlockController = UnlockController(viewModel: viewModel)
        let sheetOptions = SheetOptions(
            shrinkPresentingViewController: false
        )
        return (viewModel: viewModel, controller: .init(controller: unlockController, options: sheetOptions))
    }
    
    func makeTokensModule() -> (viewModel: TokensViewModel, controller: TokensController) {
        let viewModel = TokensViewModelImpl(tokensService: serviceFactory.makeTokensService())
        return (viewModel: viewModel, controller: .init(viewModel: viewModel))
    }
}
