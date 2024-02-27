////
////  UnlockCoordinator.swift
////  SlackLess
////
////  Created by Daniyar Kurmanbayev on 2023-09-29.
////
//
//import Foundation
//import RxCocoa
//import RxSwift
//
////  TODO: Check for memory leakage
//
//final class UnlockCoordinator: BaseCoordinator {
//    private let modulesFactory: UnlockModulesFactory
//
//    private let disposeBag = DisposeBag()
//
//    init(modulesFactory: UnlockModulesFactory) {
//        self.modulesFactory = modulesFactory
//    }
//
//    override func start() {
//        let module = modulesFactory.makeUnlockModule()
//
//        module.viewModel.output.didFinish
//            .bind(to: didFinish)
//            .disposed(by: disposeBag)
//
//        UIApplication.shared.topViewController()?.present(module.controller, animated: true)
//    }
//}
