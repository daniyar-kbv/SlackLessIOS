//
//  ReachabilityManager.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Reachability
import RxCocoa
import RxSwift

protocol ReachabilityManagerInput {
    func start()
}

protocol ReachabilityManagerOutput {
    var connectionDidChange: PublishRelay<Bool> { get }

    func getReachability() -> Bool
}

protocol ReachabilityManager: AnyObject {
    var input: ReachabilityManagerInput { get }
    var output: ReachabilityManagerOutput { get }
}

final class ReachabilityManagerImpl: ReachabilityManager, ReachabilityManagerInput, ReachabilityManagerOutput {
    private let reachability = try! Reachability()
    private lazy var lastReachability = getReachability()

    var input: ReachabilityManagerInput { self }
    var output: ReachabilityManagerOutput { self }

//    MARK: - Inputs

    func start() {
        configActions()
        startNotifier()
    }

//    MARK: - Outputs

    let connectionDidChange = PublishRelay<Bool>()

    func getReachability() -> Bool {
        return resolveReachability(connection: reachability.connection)
    }
}

extension ReachabilityManagerImpl {
    private func configActions() {
        reachability.whenReachable = { [weak self] reachability in
            self?.onReachabilityChange(self?.resolveReachability(connection: reachability.connection))
        }

        reachability.whenUnreachable = { [weak self] reachability in
            self?.onReachabilityChange(self?.resolveReachability(connection: reachability.connection))
        }
    }

    private func startNotifier() {
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    private func resolveReachability(connection: Reachability.Connection) -> Bool {
        let isReachable = [.cellular, .wifi].contains(connection)
        print("Internet connection reachable: \(isReachable)")
        return isReachable
    }

    private func onReachabilityChange(_ isReachable: Bool?) {
        guard let isReachable = isReachable,
              lastReachability != isReachable else { return }
        lastReachability = isReachable
        connectionDidChange.accept(isReachable)
    }
}
