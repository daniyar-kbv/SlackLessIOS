//
//  SurveyViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-06.
//

import Foundation
import RxSwift
import RxCocoa

protocol SurveyViewModelInput: AnyObject {
    func selectAnswer(at index: Int)
}

protocol SurveyViewModelOutput: AnyObject {
    var didFinish: PublishRelay<Void> { get }
    func getQuestion() -> SurveyQuestion
}

protocol SurveyViewModel: AnyObject {
    var input: SurveyViewModelInput { get }
    var output: SurveyViewModelOutput { get }
}

final class SurveyViewModelImpl: SurveyViewModel, SurveyViewModelInput, SurveyViewModelOutput {
    var input: SurveyViewModelInput { self }
    var output: SurveyViewModelOutput { self }
    
    private let onboardingService: OnboardingService
    private let question: SurveyQuestion
    
    init(onboardingService: OnboardingService,
         question: SurveyQuestion) {
        self.onboardingService = onboardingService
        self.question = question
    }
    
    // Output
    let didFinish: PublishRelay<Void> = .init()
    
    func getQuestion() -> SurveyQuestion {
        return question
    }
    
    // Input
    func selectAnswer(at index: Int) {
        onboardingService.input.answer(question: question, answer: question.answers[index])
        didFinish.accept(())
    }
}

