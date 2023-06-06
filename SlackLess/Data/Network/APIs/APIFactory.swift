//
//  ServiceComponents.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Moya
import RxSwift

protocol APIFactory: AnyObject {}

final class APIFactoryImpl: DependencyFactory, APIFactory {
    private lazy var defaultPlugins: [PluginType] = []
}
