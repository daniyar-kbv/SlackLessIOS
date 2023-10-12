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

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
    
    private func showFeedback() {
        let module = modulesFactory.makeFeedbackModule()
        
        router.present(module.controller, animated: true, completion: nil)
    }
}
