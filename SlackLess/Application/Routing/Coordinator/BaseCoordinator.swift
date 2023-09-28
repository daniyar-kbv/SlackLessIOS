//
//  BaseCoordinator.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import Foundation
import RxCocoa
import RxSwift

protocol Coordinator: AnyObject {
    var didFinish: PublishRelay<Void> { get }
    func start()
}

class BaseCoordinator: Coordinator {
    lazy var didFinish: PublishRelay<Void> = .init()

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
