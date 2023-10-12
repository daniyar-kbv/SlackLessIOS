//
//  FeedbackEndpoint.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-09.
//

import Foundation

enum FeedbackEndpoint: FirestoreEndpoint {
    case add(dto: SendFeedbackRequestDTO)
    
    var collectionName: String {
        switch self {
        case .add: return "feedback"
        }
    }
    
    var method: FirestoreEndpointMethod {
        switch self {
        case let .add(dto): return .create(dto: dto)
        }
    }
}
