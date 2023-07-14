//
//  SelectPriceViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-05.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectPriceViewModelInput {
    func save(timeLimit: Double)
}

protocol SelectPriceViewModelOutput {
    var timeLimitSaved: PublishRelay<Void> { get }
}

protocol SelectPriceViewModel: AnyObject {
    var input: SelectPriceViewModelInput { get }
    var output: SelectPriceViewModelOutput { get }
}

final class SelectPriceViewModelImpl: SelectPriceViewModel, SelectPriceViewModelInput, SelectPriceViewModelOutput {
    private let disposeBag = DisposeBag()
    private let appSettingsService: AppSettingsService
    
    var input: SelectPriceViewModelInput { self }
    var output: SelectPriceViewModelOutput { self }
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
        
        bindService()
    }
    
    //    Output
    var timeLimitSaved: PublishRelay<Void> = .init()
    
    //    Input
    func save(timeLimit: Double) {
        appSettingsService.input.set(timeLimit: timeLimit)
    }
}

extension SelectPriceViewModelImpl {
    private func bindService() {
        appSettingsService.output.timeLimitSaved
            .bind(to: timeLimitSaved)
            .disposed(by: disposeBag)
    }
}


