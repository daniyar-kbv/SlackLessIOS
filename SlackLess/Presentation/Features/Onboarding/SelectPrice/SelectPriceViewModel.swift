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
    private let appsSettingsService: AppsSettingsService
    
    var input: SelectPriceViewModelInput { self }
    var output: SelectPriceViewModelOutput { self }
    
    init(appsSettingsService: AppsSettingsService) {
        self.appsSettingsService = appsSettingsService
        
        bindService()
    }
    
    //    Output
    var timeLimitSaved: PublishRelay<Void> = .init()
    
    //    Input
    func save(timeLimit: Double) {
        appsSettingsService.input.save(timeLimit: timeLimit)
    }
}

extension SelectPriceViewModelImpl {
    private func bindService() {
        appsSettingsService.output.timeLimitSaved
            .bind(to: timeLimitSaved)
            .disposed(by: disposeBag)
    }
}


