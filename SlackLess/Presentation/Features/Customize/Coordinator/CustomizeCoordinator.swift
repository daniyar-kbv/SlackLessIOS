//
//  CustomizeCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-19.
//

import Foundation
import RxCocoa
import RxSwift

final class CustomizeCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let modulesFactory: CustomizeModulesFactory

    private let disposeBag = DisposeBag()
    let startUnlock: PublishRelay<Void> = .init()

    init(router: Router,
         modulesFactory: CustomizeModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeCustomizeModule()

        module.viewModel.output.startUnlock
            .bind(to: startUnlock)
            .disposed(by: disposeBag)
        
        module.viewModel.output.startFeedback
            .subscribe(onNext: { [weak self] in
                self?.showFeedback()
            })
            .disposed(by: disposeBag)

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
    
    private func showFeedback() {
        let module = modulesFactory.makeFeedbackModule()
        
        module.viewModel.output.isFinished
            .subscribe(onNext: { [weak self] in
                self?.router.pop(animated: true)
            })
            .disposed(by: disposeBag)
        
        router.push(viewController: module.controller, animated: true)
    }
}
