//
//  WeeklyReportCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-27.
//

import Foundation
import RxCocoa
import RxSwift

final class WeeklyReportCoordinator: BaseCoordinator {
    private let modulesFactory: WeeklyReportModulesFactory
    private let disposeBag = DisposeBag()

    init(modulesFactory: WeeklyReportModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeReportModule()

        module.viewModel.output.isFinished.subscribe(onNext: showSetUp)
            .disposed(by: disposeBag)

        UIApplication.shared.topViewController()?.present(module.controller, animated: true)
    }

    private func showSetUp() {
        let module = modulesFactory.makeSetUpModule()

        module.viewModel.output.didFinish.subscribe(onNext: { _ in
            UIApplication.shared.topViewController()?.dismissAll(animated: true, completion: { [weak self] in
                self?.didFinish.accept(())
            })
        })
        .disposed(by: disposeBag)

        UIApplication.shared.topViewController()?.present(module.controller, animated: true)
    }
}
