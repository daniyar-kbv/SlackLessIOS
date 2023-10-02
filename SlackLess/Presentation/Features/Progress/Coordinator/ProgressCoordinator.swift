//
//  ProgressCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import RxCocoa
import RxSwift

final class ProgressCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let modulesFactory: ProgressModulesFactory

    private let disposeBag = DisposeBag()
    let startUnlock: PublishRelay<Void> = .init()

    init(router: Router,
         modulesFactory: ProgressModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeProgressModule()

        module.viewModel.output.startUnlock
            .bind(to: startUnlock)
            .disposed(by: disposeBag)

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
}
