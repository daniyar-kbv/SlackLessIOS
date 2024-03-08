//
//  OnboardingCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

//  TODO: Check for memroy leakage

final class OnboardingCoordinator: BaseCoordinator {
    private let disposeBag = DisposeBag()
    private(set) var router: Router

    private let modulesFactory: OnboardingModulesFactory

    init(router: Router,
         modulesFactory: OnboardingModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeWelcomeScreenModule()

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))

        module.viewModel.output.didFinish
            .subscribe(onNext: { [weak self] in
                self?.showSurvey(for: .question1)
            })
            .disposed(by: disposeBag)

        UIApplication.shared.set(rootViewController: router.getNavigationController())
    }
    
    private func showSurvey(for question: SurveyQuestion) {
        let module = modulesFactory.makeSurveyModule(for: question)
        
        module.viewModel.output.didFinish
            .subscribe(onNext: { [weak self] in
                switch question {
                case .question1: self?.showSurvey(for: .question2)
                case .question2: self?.showRequestAuth()
                }
            })
            .disposed(by: disposeBag)
        
        router.push(viewController: module.controller, animated: true)
    }

    private func showRequestAuth() {
        let module = modulesFactory.makeRequestAuthModule()

        module.viewModel.output.authorizationSuccessful
            .subscribe(onNext: { [weak self] in
                self?.showSetUp()
            })
            .disposed(by: disposeBag)

        router.push(viewController: module.controller, animated: true)
    }

    private func showSetUp() {
        let module = modulesFactory.makeSetUpModule()

        module.viewModel.output.didFinish
            .bind(to: didFinish)
            .disposed(by: disposeBag)

        router.push(viewController: module.controller, animated: true)
    }
}
