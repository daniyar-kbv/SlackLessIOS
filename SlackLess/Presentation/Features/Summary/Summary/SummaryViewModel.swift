//
//  SummaryViewMode.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import RxCocoa
import RxSwift

protocol SummaryViewModelInput {
    func terminate()
}

protocol SummaryViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }

//    Output
    var didFinish: PublishRelay<Void> = .init()

//    Input
    func terminate() {
        didFinish.accept(())
    }
}
