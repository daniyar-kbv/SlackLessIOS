//
//  FeedbackViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import RxSwift
import RxCocoa

protocol FeedbackViewModelInput: AnyObject {
    func didFinishEditing(text: String, type: FeedbackView.FieldType)
    func submit()
    func finish()
}

protocol FeedbackViewModelOutput: AnyObject {
    var isComplete: BehaviorRelay<Bool> { get }
    var feedbackSent: PublishRelay<Void> { get }
    var validationErrorOccured: PublishRelay<FeedbackController.Error> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var isFinished: PublishRelay<Void> { get }
}

protocol FeedbackViewModel: AnyObject {
    var input: FeedbackViewModelInput { get }
    var output: FeedbackViewModelOutput { get }
}

final class FeedbackViewModelImpl: FeedbackViewModel, FeedbackViewModelInput, FeedbackViewModelOutput {
    var input: FeedbackViewModelInput { self }
    var output: FeedbackViewModelOutput { self }
    
    private let feedbackService: FeedbackService
    
    private let disposeBag = DisposeBag()
    private var email = ""
    private var body = "" {
        didSet {
            didEditBody = true
        }
    }
    private var didEditBody = false
    
    init(feedbackService: FeedbackService) {
        self.feedbackService = feedbackService
        
        bindFeedbackService()
    }
    
    //    Output
    let isComplete: BehaviorRelay<Bool> = .init(value: false)
    var feedbackSent: PublishRelay<Void> = .init()
    let validationErrorOccured: PublishRelay<FeedbackController.Error> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    var isFinished: PublishRelay<Void> = .init()
    
    //    Input
    func didFinishEditing(text: String, type: FeedbackView.FieldType) {
        switch type {
        case .email: email = text
        case .body: body = text
        }

        validate()
    }
    
    func submit() {
        guard isComplete.value else { return }
        feedbackService.input.sendFeedback(body: body, email: email)
    }
    
    func finish() {
        isFinished.accept(())
    }
}

extension FeedbackViewModelImpl {
    private func bindFeedbackService() {
        feedbackService.output.feedbackSent
            .bind(to: feedbackSent)
            .disposed(by: disposeBag)
        
        feedbackService.output.errorOccured
            .bind(to: errorOccured)
            .disposed(by: disposeBag)
    }
    
    private func validate() {
        let emailValid = email.isEmpty || email.isValidEmail()
        if !emailValid {
            validationErrorOccured.accept(.invalidEmail)
        }
        
        if didEditBody && body.isEmpty {
            validationErrorOccured.accept(.emptyBody)
        }
        
        isComplete.accept(emailValid && !body.isEmpty)
    }
}
