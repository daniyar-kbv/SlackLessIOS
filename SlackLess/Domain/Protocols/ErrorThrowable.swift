//
//  ErrorThrowable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift

protocol ErrorThrowable {
    typealias Element = Any

    func subscribe(errorRelay: PublishRelay<ErrorPresentable>?,
                   onSuccess: @escaping (Element) -> Void) -> Disposable
}

extension PrimitiveSequenceType where Trait == SingleTrait {
    func subscribe(errorRelay: PublishRelay<ErrorPresentable>?,
                   onSuccess: @escaping (Element) -> Void) -> Disposable
    {
        return subscribe(onSuccess: onSuccess) { error in
            guard let errorRelay = errorRelay,
                  let error = error as? ErrorPresentable
            else { return }
            errorRelay.accept(error)
        }
    }
}
