//
//  IntroductionViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-10.
//

import Foundation
import RxCocoa
import RxSwift

protocol IntroductionViewModelInput: AnyObject {
    func buttonTapped()
    func scrolled(to index: Int)
    func finish()
}

protocol IntroductionViewModelOutput: AnyObject {
    var reloadData: PublishRelay<Void> { get }
    var buttonTitle: BehaviorRelay<String> { get }
    var numberOfStates: BehaviorRelay<Int> { get }
    var currentStateIndex: BehaviorRelay<Int> { get }
    var didFinish: PublishRelay<Void> { get }
    func getState(at index: Int) -> IntroductionState?
}

protocol IntroductionViewModel: AnyObject {
    var input: IntroductionViewModelInput { get }
    var output: IntroductionViewModelOutput { get }
}

final class IntroductionViewModelImpl: IntroductionViewModel, IntroductionViewModelInput, IntroductionViewModelOutput {
    var input: IntroductionViewModelInput { self }
    var output: IntroductionViewModelOutput { self }
    
    private let states: [IntroductionState] = [.summary, .lock, .progress]
    private lazy var currentIndex = 0 {
        didSet { refresh() }
    }
    
//    Output
    let reloadData = PublishRelay<Void>()
    lazy var buttonTitle = BehaviorRelay<String>(value: states[currentIndex].buttonTitle)
    lazy var numberOfStates = BehaviorRelay<Int>(value: states.count)
    lazy var currentStateIndex = BehaviorRelay<Int>(value: currentIndex)
    let didFinish = PublishRelay<Void>()
    
    func getState(at index: Int) -> IntroductionState? {
        guard index < states.count else { return nil }
        return states[index]
    }
    
//    Input
    func buttonTapped() {
        if currentIndex >= states.count - 1 {
            didFinish.accept(())
        } else {
            currentIndex += 1
        }
    }
    
    func scrolled(to index: Int) {
        currentIndex = index
    }
    
    func finish() {
        didFinish.accept(())
    }
}

extension IntroductionViewModelImpl {
    private func refresh() {
        reloadData.accept(())
        buttonTitle.accept(states[currentIndex].buttonTitle)
        numberOfStates.accept(states.count)
        currentStateIndex.accept(currentIndex)
    }
}
