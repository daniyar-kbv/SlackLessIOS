//
//  Event.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

class Event {
    let type: EventType
    let value: Any?

    init(type: EventType, value: Any? = nil) {
        self.type = type
        self.value = value
    }
}
