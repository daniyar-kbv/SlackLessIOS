//
//  OnboardingCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class OnboardingCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private(set) var router: Router

    private let modulesFactory: OnboardingModulesFactory

    var didTerminate: (() -> Void)?
    var didFinish: (() -> Void)?

    init(router: Router,
         modulesFactory: OnboardingModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeWelcomeScreenModule()

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
        router.getNavigationController().isNavigationBarHidden = true
        
        module.viewModel.output.didFinish
            .subscribe(onNext: { [weak self] in
                self?.showRequestAuth()
            })
            .disposed(by: disposeBag)

        UIApplication.shared.set(rootViewController: router.getNavigationController())
    }
    
    private func showRequestAuth() {
        let module = modulesFactory.makeRequestAuthModule()
        
        module.viewModel.output.authorizationComplete
            .subscribe(onNext: { [weak self] in
                self?.showSelectApps()
            })
            .disposed(by: disposeBag)
        
        router.push(viewController: module.controller, animated: true)
    }
    
    private func showSelectApps() {
        let module = modulesFactory.makeSelectAppsModule()
        
        module.viewModel.output.appsSelected
            .subscribe(onNext: { [weak self] in
                self?.showSelectPrices()
            })
            .disposed(by: disposeBag)
        
        router.push(viewController: module.controller, animated: true)
    }
    
    private func showSelectPrices() {
        let module = modulesFactory.makeSelectPriceModule()
        
        module.viewModel.output.timeLimitSaved
            .subscribe(onNext: { [weak self] in
                self?.didFinish?()
            })
            .disposed(by: disposeBag)
        
        router.push(viewController: module.controller, animated: true)
    }
}
