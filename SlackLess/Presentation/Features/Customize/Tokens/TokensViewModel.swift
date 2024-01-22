//
//  TokensViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-15.
//

import Foundation
import RxSwift
import RxCocoa

protocol TokensViewModelInput: AnyObject {
    func set(tokens: String)
    func submit()
    func finish()
}

protocol TokensViewModelOutput: AnyObject {
    var alert: PublishRelay<IAPManagerAlertType> { get }
    var isFinished: PublishRelay<Void> { get }
}

protocol TokensViewModel: AnyObject {
    var input: TokensViewModelInput { get }
    var output: TokensViewModelOutput { get }
}

final class TokensViewModelImpl: TokensViewModel, TokensViewModelInput, TokensViewModelOutput {
    var input: TokensViewModelInput { self }
    var output: TokensViewModelOutput { self }
    
    private let tokensService: TokensService
    private let disposeBag = DisposeBag()
    private var tokens = 0
    
    init(tokensService: TokensService) {
        self.tokensService = tokensService
        
        tokensService.output.alert
            .bind(to: alert)
            .disposed(by: disposeBag)
    }
    
    //    Output
    let alert: PublishRelay<IAPManagerAlertType> = .init()
    let isFinished: PublishRelay<Void> = .init()
    
    //    Input
    func set(tokens: String) {
        self.tokens = Int(tokens) ?? 0
    }
    
    func submit() {
        tokensService.input.purchase(tokens: tokens)
    }
    
    func finish() {
        isFinished.accept(())
    }
}
