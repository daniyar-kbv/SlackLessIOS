//
//  ResultsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import RxCocoa
import RxSwift

protocol ResultsViewModelInput: AnyObject {
    func buttonTapped()
}

protocol ResultsViewModelOutput: AnyObject {
    var state: BehaviorRelay<ResultsState> { get }
    var didFinish: PublishRelay<Void> { get }
}

protocol ResultsViewModel: AnyObject {
    var input: ResultsViewModelInput { get }
    var output: ResultsViewModelOutput { get }
}

final class ResultsViewModelImpl: ResultsViewModel, ResultsViewModelInput, ResultsViewModelOutput {
    var input: ResultsViewModelInput { self }
    var output: ResultsViewModelOutput { self }
    
    private let disposeBag = DisposeBag()
    private let onboardingService: OnboardingService
    private lazy var results = onboardingService.output.getResults()
    
    init(onboardingService: OnboardingService) {
        self.onboardingService = onboardingService
    }
    
//    Output
    lazy var state: BehaviorRelay<ResultsState> = .init(value: .spend(year: results.spendYear.getMaxTimeUnit(),
                                                                      life: results.spendLife.getMaxTimeUnit()))
    var didFinish: PublishRelay<Void> = .init()
    
//    Input
    func buttonTapped() {
        switch state.value {
        case .spend: state.accept(.save(life: results.save.getMaxTimeUnit()))
        case .save: didFinish.accept(())
        }
    }
}
