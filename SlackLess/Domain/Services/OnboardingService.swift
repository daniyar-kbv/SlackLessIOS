//
//  OnboardingService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import FamilyControls
import RxSwift
import RxCocoa

protocol OnboardingServiceInput: AnyObject {
    func answer(question: SurveyQuestion, answer: SurveyQuestion.Answer)
    func requestAuthorization()
    func set(onboardingShown: Bool)
}

protocol OnboardingServiceOutput: AnyObject {
    var authorizationComplete: PublishRelay<Void> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    func getOnboardingShown() -> Bool
    func getResults() -> (spendYear: TimeInterval, spendLife: TimeInterval, save: TimeInterval)
    func getBenefits() -> (time: TimeInterval, percentage: Double)
}

protocol OnboardingService: AnyObject {
    var input: OnboardingServiceInput { get }
    var output: OnboardingServiceOutput { get }
}

final class OnboardingServiceImpl: OnboardingService, OnboardingServiceInput, OnboardingServiceOutput {
    var input: OnboardingServiceInput { self }
    var output: OnboardingServiceOutput { self }
    
    private let disposeBag = DisposeBag()
    private let appSettingsRepository: AppSettingsRepository
    private var answeredQuestions: [(question: SurveyQuestion, answer: SurveyQuestion.Answer)] = []
    
    init(appSettingsRepository: AppSettingsRepository) {
        self.appSettingsRepository = appSettingsRepository
    }
    
//    Output
    let authorizationComplete: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    
    func getOnboardingShown() -> Bool {
        appSettingsRepository.output.getOnboardingShown()
    }
    
    func getResults() -> (spendYear: TimeInterval, spendLife: TimeInterval, save: TimeInterval) {
        guard let screenTime = answeredQuestions.first(where: { $0.question == .question1 })?.answer.value,
              let age = answeredQuestions.first(where: { $0.question == .question2 })?.answer.value
        else { return (spendYear: 0, spendLife: 0, save: 0) }
        let spendYear = TimeInterval(screenTime*3600*365)
        let spendLife = TimeInterval(79-age)*spendYear
        let save = spendLife*0.2
        return (spendYear: spendYear, spendLife: spendLife, save: save)
    }
    
    func getBenefits() -> (time: TimeInterval, percentage: Double) {
        guard let screenTime = answeredQuestions.first(where: { $0.question == .question1 })?.answer.value,
              let dayData = appSettingsRepository.output.getDayData(for: Date().getDate())
        else {
            return (time: 3600.0,
                    percentage: 0.1)
        }
        
        let screenTime_ = TimeInterval(screenTime*3600)
        let time = (screenTime_*0.5)-dayData.timeLimit
        let percentage = time/screenTime_
        
        if percentage < 0.1 {
            return (time: screenTime_*0.1, percentage: 0.1)
        } else {
            return (time: time, percentage: percentage)
        }
    }
    
//    Input
    func answer(question: SurveyQuestion, answer: SurveyQuestion.Answer) {
        if let index = answeredQuestions.firstIndex(where: { $0.question == question }) {
            answeredQuestions[index].answer = answer
        } else {
            answeredQuestions.append((question: question, answer: answer))
        }
    }
    
    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: FamilyControlsMember.individual)
                DispatchQueue.main.async { [weak self] in
                    self?.authorizationComplete.accept(())
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    switch error as? FamilyControlsError {
                    case .authorizationCanceled: self?.errorOccured.accept(DomainError.familyControlsAuthorizationDenied)
                    default: self?.errorOccured.accept(DomainError.error(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func set(onboardingShown: Bool) {
        appSettingsRepository.input.set(onboardingShown: onboardingShown)
    }
}

