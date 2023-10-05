//
//  HelpersFactory.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

protocol HelpersFactory: AnyObject {
    func makeReachabilityManager() -> ReachabilityManager
    func makeEventManager() -> EventManager
}

final class HelpersFactoryImpl: DependencyFactory, HelpersFactory {
    func makeReachabilityManager() -> ReachabilityManager {
        return shared(ReachabilityManagerImpl())
    }

    func makeEventManager() -> EventManager {
        return shared(EventManagerImpl())
    }
}
