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
}

final class UnlockModulesFactoryImpl: UnlockModulesFactory {
    private let serviceFactory: ServiceFactory

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: SheetViewController) {
        let viewModel = UnlockViewModelImpl(appSettingsService: serviceFactory.makeAppSettingsService(),
                                            paymentService: serviceFactory.makePaymentService(),
                                            lockService: serviceFactory.makeLockService())
        let unlockController = UnlockController(viewModel: viewModel)
        let sheetOptions = SheetOptions(
            shrinkPresentingViewController: false
        )
        return (viewModel: viewModel, controller: .init(controller: unlockController, options: sheetOptions))
    }
}
