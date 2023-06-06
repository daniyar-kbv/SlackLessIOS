//
//  Coordinator.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import Foundation

protocol Coordinator: AnyObject {
    var onFinish: (() -> Void)? { get set }
    func start()
}

class BaseCoordinator: Coordinator {
    var onFinish: (() -> Void)?

    private(set) var childCoordinators: [Coordinator] = []

    func start() {}

    func add(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

    func remove(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else { return }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
