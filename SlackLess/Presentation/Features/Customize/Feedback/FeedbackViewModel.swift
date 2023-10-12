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
    func didFinishEditing(text: String?, type: FeedbackView.FieldType)
}

protocol FeedbackViewModelOutput: AnyObject {
    var isComplete: BehaviorRelay<Bool> { get }
    var errorOccured: PublishRelay<FeedbackController.Error> { get }
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
    private var email: String?
    private var body: String? {
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
    let errorOccured: PublishRelay<FeedbackController.Error> = .init()
    
    //    Input
    func didFinishEditing(text: String?, type: FeedbackView.FieldType) {
        switch type {
        case .email: email = text
        case .body: body = text
        }

        validate()
    }
}

extension FeedbackViewModelImpl {
    private func bindFeedbackService() {
        
    }
    
    private func validate() {
        let emailValid = email?.isValidEmail() ?? true
        let bodyEmpty = body?.isEmpty ?? true
        
        if !emailValid {
            errorOccured.accept(.invalidEmail)
        }
        
        if didEditBody && bodyEmpty {
            errorOccured.accept(.emptyBody)
        }
        
        isComplete.accept(emailValid && !bodyEmpty)
    }
}
