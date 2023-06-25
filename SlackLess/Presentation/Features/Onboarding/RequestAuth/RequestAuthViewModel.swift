//
//  RequestAuthViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import RxSwift
import RxCocoa

protocol RequestAuthViewModelInput {
    func requestAuthorization()
}

protocol RequestAuthViewModelOutput {
    var authorizationComplete: PublishRelay<Void> { get }
}

protocol RequestAuthViewModel: AnyObject {
    var input: RequestAuthViewModelInput { get }
    var output: RequestAuthViewModelOutput { get }
}

final class RequestAuthViewModellImpl: RequestAuthViewModel, RequestAuthViewModelInput, RequestAuthViewModelOutput {
    private let disposeBag = DisposeBag()
    private let screenTimeService: ScreenTimeService
    
    var input: RequestAuthViewModelInput { self }
    var output: RequestAuthViewModelOutput { self }
    
    init(screenTimeService: ScreenTimeService) {
        self.screenTimeService = screenTimeService
    }
    
    //    Output
    var authorizationComplete: PublishRelay<Void> = .init()
    
    //    Input
    func requestAuthorization() {
        screenTimeService.input.requestAuthorization()
    }
}

extension RequestAuthViewModellImpl {
    private func bindService() {
        screenTimeService.output.authorizaionStatus
            .subscribe(onNext: { [weak self] _ in
                self?.authorizationComplete.accept(())
            })
            .disposed(by: disposeBag)
    }
}

