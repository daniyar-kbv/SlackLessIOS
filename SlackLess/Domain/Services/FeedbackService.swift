//
//  FeedbackService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import RxSwift
import RxCocoa

protocol FeedbackServiceInput: AnyObject {
    func sendFeedback(body: String, email: String?)
}

protocol FeedbackServiceOutput: AnyObject {
    var errorOccured: PublishRelay<ErrorPresentable> { get }
    var feedbackSent: PublishRelay<Void> { get }
}

protocol FeedbackService: AnyObject {
    var input: FeedbackServiceInput { get }
    var output: FeedbackServiceOutput { get }
}

final class FeedbackServiceImpl: FeedbackService, FeedbackServiceInput, FeedbackServiceOutput {
    var input: FeedbackServiceInput { self }
    var output: FeedbackServiceOutput { self }
    
    private let feedbackAPI: FeedbackAPI
    
    private let disposeBag = DisposeBag()
    
    init(feedbackAPI: FeedbackAPI) {
        self.feedbackAPI = feedbackAPI
    }
    
    //    Output
    let feedbackSent: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    
    //    Input
    func sendFeedback(body: String, email: String?) {
        guard email?.isValidEmail() ?? true else {
            errorOccured.accept(DomainError.invalidEmail)
            return
        }
        
        feedbackAPI.sendFeedback(dto: .init(body: body, email: email))
            .subscribe(errorRelay: errorOccured) { [weak self] _ in
                self?.feedbackSent.accept(())
            }
            .disposed(by: disposeBag)
    }
}
