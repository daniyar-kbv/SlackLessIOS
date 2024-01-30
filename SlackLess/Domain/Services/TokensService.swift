//
//  TokensService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-16.
//

import Foundation
import RxCocoa
import RxSwift

protocol TokensServiceInput {
    func purchase(tokens: Int)
    func use(tokens: Int)
    func restore()
}

protocol TokensServiceOutput {
    var alert: PublishRelay<IAPManagerAlertType> { get }
    func getTokens() -> Int
}

protocol TokensService: AnyObject {
    var input: TokensServiceInput { get }
    var output: TokensServiceOutput { get }
}

final class TokensServiceImpl: TokensService, TokensServiceInput, TokensServiceOutput {
    var input: TokensServiceInput { self }
    var output: TokensServiceOutput { self }
    
    private let tokensRepository: TokensRepository
    private let iapManager: IAPManager
    private let disposeBag = DisposeBag()
    private var pendingTokens: Int?
    
    let alert: PublishRelay<IAPManagerAlertType> = .init()
    
    init(tokensRepository: TokensRepository,
         iapManager: IAPManager) {
        self.tokensRepository = tokensRepository
        self.iapManager = iapManager
        
        iapManager.purchaseStatusBlock = { [weak self] alertType in
            switch alertType {
            case .purchased:
                guard let tokens = self?.pendingTokens else { break }
                self?.tokensRepository.input.purchase(tokens: tokens)
            default: break
            }
            self?.output.alert.accept(alertType)
            self?.pendingTokens = nil
        }
    }
    
//    Output
    func getTokens() -> Int {
        return tokensRepository.output.getPurchasedTokens() - tokensRepository.output.getUsedTokens()
    }
    
//    Input
    func purchase(tokens: Int) {
        pendingTokens = tokens
        iapManager.purchaseMyProduct(productIdentifier: Constants.IAP.Products.oneCredit.rawValue,
                                     quantity: tokens)
    }
    
    func use(tokens: Int) {
        tokensRepository.input.use(tokens: tokens)
    }
    
    func restore() {
        tokensRepository.input.restore()
        output.alert.accept(.restored)
    }
}
