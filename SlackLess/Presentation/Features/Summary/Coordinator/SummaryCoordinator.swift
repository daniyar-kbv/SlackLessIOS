//
//  SummaryCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

final class SummaryCoordinator: BaseCoordinator {
    private(set) var router: Router

    private let modulesFactory: SummaryModulesFactory

    private let disposeBag = DisposeBag()
    let startUnlock: PublishRelay<Void> = .init()

    init(router: Router,
         modulesFactory: SummaryModulesFactory)
    {
        self.router = router
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeSummaryModule()

        module.viewModel.output.startUnlock
            .bind(to: startUnlock)
            .disposed(by: disposeBag)

        router.set(navigationController: SLNavigationController(rootViewController: module.controller))
    }
}
