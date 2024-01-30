//
//  UnlockCoordinator.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-29.
//

import Foundation
import RxCocoa
import RxSwift

//  TODO: Check for memory leakage

final class UnlockCoordinator: BaseCoordinator {
    private let modulesFactory: UnlockModulesFactory

    private let disposeBag = DisposeBag()

    init(modulesFactory: UnlockModulesFactory) {
        self.modulesFactory = modulesFactory
    }

    override func start() {
        let module = modulesFactory.makeUnlockModule()

        module.viewModel.output.didFinish
            .bind(to: didFinish)
            .disposed(by: disposeBag)
        
        module.viewModel.output.startTokens
            .subscribe(onNext: { [weak self] in
                self?.showTokens(on: module.controller)
            })
            .disposed(by: disposeBag)

        UIApplication.shared.topViewController()?.present(module.controller, animated: true)
    }
    
    private func showTokens(on viewController: UIViewController) {
        let module = modulesFactory.makeTokensModule()
        
        module.viewModel.output.isFinished
            .subscribe(onNext: { 
                module.controller.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewController.present(module.controller, animated: true)
    }
}
