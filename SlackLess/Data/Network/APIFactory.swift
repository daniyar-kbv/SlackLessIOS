//
//  ServiceComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Moya
import RxSwift

protocol APIFactory: AnyObject {
    func makeFeedbackAPI() -> FeedbackAPI
}

final class APIFactoryImpl: DependencyFactory, APIFactory {
    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
    private lazy var defaultPlugins: [PluginType] = [networkPlugin]
    
    func makeFeedbackAPI() -> FeedbackAPI {
        shared(FeedbackAPIImpl(firestoreClient: .init()))
    }
}
