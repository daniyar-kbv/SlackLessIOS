//
//  EventObserver.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift

final class EventObservable {
    let eventType: EventType
    let observable: PublishRelay<Event>

    init(eventType: EventType,
         observable: PublishRelay<Event>)
    {
        self.eventType = eventType
        self.observable = observable
    }
}

extension Array where Element: EventObservable {
    func getObservable(of type: EventType) -> EventObservable? {
        return first(where: { $0.eventType == type })
    }
}
