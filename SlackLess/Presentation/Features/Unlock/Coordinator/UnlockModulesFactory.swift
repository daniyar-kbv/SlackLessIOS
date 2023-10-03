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
    private let appSettingsService: AppSettingsService
    private let paymentService: PaymentService
    private let lockService: LockService

    init(appSettingsService: AppSettingsService,
         paymentService: PaymentService,
         lockService: LockService) {
        self.appSettingsService = appSettingsService
        self.paymentService = paymentService
        self.lockService = lockService
    }

    func makeUnlockModule() -> (viewModel: UnlockViewModel, controller: SheetViewController) {
        let viewModel = UnlockViewModelImpl(appSettingsService: appSettingsService,
                                            paymentService: paymentService,
                                            lockService: lockService)
        let unlockController = UnlockController(viewModel: viewModel)
        let sheetOptions = SheetOptions(
            shrinkPresentingViewController: false
        )
        return (viewModel: viewModel, controller: .init(controller: unlockController, options: sheetOptions))
    }
}
