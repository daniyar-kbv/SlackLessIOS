//
//  ServiceComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Moya
import RxSwift

protocol APIFactory: AnyObject {
    func makeITunesAPI() -> ITunesAPI
}

final class APIFactoryImpl: DependencyFactory, APIFactory {
    private let networkPlugin = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))
    
    private lazy var defaultPlugins: [PluginType] = []
    private lazy var provider = MoyaProvider<ITunesTarget>(plugins: defaultPlugins)
    
    func makeITunesAPI() -> ITunesAPI {
        weakShared(ITunesAPIImpl(provider: provider))
    }
}
