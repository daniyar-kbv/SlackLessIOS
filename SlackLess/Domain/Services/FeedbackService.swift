//
//  FeedbackService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import DeviceKit
import RxSwift
import RxCocoa

protocol FeedbackServiceInput: AnyObject {
    func sendFeedback(body: String, email: String)
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
    func sendFeedback(body: String, email: String) {
        guard email.isEmpty || email.isValidEmail() else {
            errorOccured.accept(DomainError.invalidEmail)
            return
        }
        
        let dto = SendFeedbackRequestDTO(
            body: body,
            email: email,
            os: Device.current.systemName,
            device: Device.current.safeDescription,
            systemVersion: Device.current.systemVersion,
            appVersion: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "",
            buildNumber: (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        )
        
        feedbackAPI.sendFeedback(dto: dto)
            .subscribe(
                onSuccess: { [weak self] _ in
                    self?.feedbackSent.accept(())
                }, onError: { [weak self] in
                    guard let error = $0 as? ErrorPresentable else { return }
                    self?.errorOccured.accept(error)
                })
            .disposed(by: disposeBag)
    }
}
