//
//  FeedbackAPI.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol FeedbackAPI: AnyObject {
    func sendFeedback(dto: SendFeedbackRequestDTO) -> Single<FirestoreDocumentID>
}

final class FeedbackAPIImpl: FeedbackAPI {
    private let firestoreClient: FirestoreClient<FeedbackEndpoint>
    
    init(firestoreClient: FirestoreClient<FeedbackEndpoint>) {
        self.firestoreClient = firestoreClient
    }
    
    func sendFeedback(dto: SendFeedbackRequestDTO) -> Single<FirestoreDocumentID> {
        firestoreClient.request(.add(dto: dto))
    }
}
