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
    var date: BehaviorRelay<String> { get }
    
}

protocol SummaryViewModel: AnyObject {
    var input: SummaryViewModelInput { get }
    var output: SummaryViewModelOutput { get }
}

final class SummaryViewModelImpl: SummaryViewModel, SummaryViewModelInput, SummaryViewModelOutput {
    var input: SummaryViewModelInput { self }
    var output: SummaryViewModelOutput { self }

//    Output
    let didFinish: PublishRelay<Void> = .init()
    lazy var date: BehaviorRelay<String> = .init(value: format(date: Date()))

//    Input
    func terminate() {
        didFinish.accept(())
    }
}

extension SummaryViewModelImpl {
    private func format(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, EEEE"
        return dateFormatter.string(from: date)
    }
}
