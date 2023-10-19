//
//  AsyncSequenceExtension.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-14.
//

import Foundation

extension AsyncSequence {
    func unwrap<T>() async -> [T] {
        var unwrapped: [T] = []
        
        do {
            for try await element in self {
                if let element = element as? T {
                    unwrapped.append(element)
                }
            }
        } catch {
            print(error)
        }

        return unwrapped
    }
}
