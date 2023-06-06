//
//  EventManager.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift

protocol EventManagerInput {
    func send(event: Event)
    func subscribe(to eventType: EventType, disposeBag: DisposeBag, onEvent: @escaping (Event) -> Void)
}

protocol EventManagerOutput {}

protocol EventManager {
    var input: EventManagerInput { get }
    var output: EventManagerOutput { get }
}

final class EventManagerImpl: EventManager, EventManagerInput, EventManagerOutput {
    var input: EventManagerInput { self }
    var output: EventManagerOutput { self }

    private let disposeBag = DisposeBag()

    private let eventObservables = EventType.allCases.map { EventObservable(eventType: $0, observable: .init()) }

    init() {}

//    Inputs

    func send(event: Event) {
        guard let eventObservable = eventObservables.getObservable(of: event.type) else { return }
        eventObservable.observable.accept(event)
    }

    func subscribe(to eventType: EventType,
                   disposeBag: DisposeBag,
                   onEvent: @escaping (Event) -> Void)
    {
        guard let eventObservable = eventObservables.getObservable(of: eventType) else { return }

        eventObservable
            .observable
            .subscribe(onNext: { event in
                onEvent(event)
            })
            .disposed(by: disposeBag)
    }
}
