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
    var authorizationSuccessful: PublishRelay<Void> { get }
    var gotError: PublishRelay<String> { get }
}

protocol RequestAuthViewModel: AnyObject {
    var input: RequestAuthViewModelInput { get }
    var output: RequestAuthViewModelOutput { get }
}

final class RequestAuthViewModellImpl: RequestAuthViewModel, RequestAuthViewModelInput, RequestAuthViewModelOutput {
    private let disposeBag = DisposeBag()
    private let appSettingsService: AppSettingsService
    
    var input: RequestAuthViewModelInput { self }
    var output: RequestAuthViewModelOutput { self }
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
        
        bindService()
    }
    
    //    Output
    var authorizationComplete: PublishRelay<Void> = .init()
    var authorizationSuccessful: PublishRelay<Void> = .init()
    var gotError: PublishRelay<String> = .init()
    
    //    Input
    func requestAuthorization() {
        appSettingsService.input.requestAuthorization()
    }
}

extension RequestAuthViewModellImpl {
    private func bindService() {
        appSettingsService.output.authorizaionStatus
            .subscribe(onNext: { [weak self] in
                self?.authorizationComplete.accept(())
                switch $0 {
                case .success:
                    self?.authorizationSuccessful.accept(())
                case let .failure(error):
                    self?.gotError.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}

