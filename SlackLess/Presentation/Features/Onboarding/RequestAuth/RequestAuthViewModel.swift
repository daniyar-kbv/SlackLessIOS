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
    var gotError: PublishRelay<ErrorPresentable> { get }
    var didFinish: PublishRelay<Void> { get }
}

protocol RequestAuthViewModel: AnyObject {
    var input: RequestAuthViewModelInput { get }
    var output: RequestAuthViewModelOutput { get }
}

final class RequestAuthViewModellImpl: RequestAuthViewModel, RequestAuthViewModelInput, RequestAuthViewModelOutput {
    private let disposeBag = DisposeBag()
    private let onboardingService: OnboardingService
    
    var input: RequestAuthViewModelInput { self }
    var output: RequestAuthViewModelOutput { self }
    
    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
        
        bindService()
    }
    
    //    Output
    var authorizationComplete: PublishRelay<Void> = .init()
    var gotError: PublishRelay<ErrorPresentable> = .init()
    var didFinish: PublishRelay<Void> = .init()
    
    //    Input
    func requestAuthorization() {
        onboardingService.input.requestAuthorization()
    }
}

extension RequestAuthViewModellImpl {
    private func bindService() {
        onboardingService.output.authorizationComplete
            .subscribe(onNext: { [weak self] in
                self?.authorizationComplete.accept(())
                self?.didFinish.accept(())
            })
            .disposed(by: disposeBag)
        
        onboardingService.output.errorOccured
            .subscribe(onNext: { [weak self] in
                self?.gotError.accept($0)
            })
            .disposed(by: disposeBag)
    }
}

