//
//  TokensRepository.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-01-17.
//

import Foundation

protocol TokensRepositoryInput {
    func purchase(tokens: Int)
    func use(tokens: Int)
    func reset(tokens: Int)
}

protocol TokensRepositoryOutput {
    func getPurchasedTokens() -> Int
    func getUsedTokens() -> Int
}

protocol TokensRepository: AnyObject {
    var input: TokensRepositoryInput { get }
    var output: TokensRepositoryOutput { get }
}

final class TokensRepositoryImpl: TokensRepository, TokensRepositoryInput, TokensRepositoryOutput {
    var input: TokensRepositoryInput { self }
    var output: TokensRepositoryOutput { self }
    
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
//    Output
    func purchase(tokens: Int) {
        var purchasedTokens = keyValueStorage.purchasedTokens
        purchasedTokens += tokens
        keyValueStorage.persist(purchasedTokens: purchasedTokens)
    }
    
    func use(tokens: Int) {
        var usedTokens = keyValueStorage.usedTokens
        usedTokens += tokens
        keyValueStorage.persist(usedTokens: usedTokens)
    }
    
    func reset(tokens: Int) {
        keyValueStorage.persist(purchasedTokens: tokens)
    }
    
//    Input
    func getPurchasedTokens() -> Int {
        keyValueStorage.purchasedTokens
    }
    
    func getUsedTokens() -> Int {
        keyValueStorage.usedTokens
    }
}
