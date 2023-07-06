//
//  AppsSettingsService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppsSettingsServiceInput {
    func save(timeLimit: Double)
}

protocol AppsSettingsServiceOutput {
    var timeLimitSaved: PublishRelay<Void> { get }
    
    func getTimeLimit() -> Double?
}

protocol AppsSettingsService: AnyObject {
    var input: AppsSettingsServiceInput { get }
    var output: AppsSettingsServiceOutput { get }
}

final class AppsSettingsServiceImpl: AppsSettingsService, AppsSettingsServiceInput, AppsSettingsServiceOutput {
    var input: AppsSettingsServiceInput { self }
    var output: AppsSettingsServiceOutput { self }
    
    private let keyValueStorage: KeyValueStorage
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    //    Output
    var timeLimitSaved: PublishRelay<Void> = .init()
    
    func getTimeLimit() -> Double? {
        keyValueStorage.timelimit
    }
    
    //    Input
    func save(timeLimit: Double) {
        keyValueStorage.persist(timeLimit: timeLimit)
        timeLimitSaved.accept(())
    }
}
