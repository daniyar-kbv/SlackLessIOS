//
//  WelcomeScreenViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-31.
//

import Foundation
import RxCocoa
import RxSwift

protocol WelcomeScreenViewModelInput {
    func terminate()
}

protocol WelcomeScreenViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
}

protocol WelcomeScreenViewModel: AnyObject {}

final class WelcomeScreenViewModelImpl: WelcomeScreenViewModel, WelcomeScreenViewModelInput, WelcomeScreenViewModelOutput {
    var input: WelcomeScreenViewModelInput { self }
    var output: WelcomeScreenViewModelOutput { self }

//    Output
    var didFinish: PublishRelay<Void> = .init()

//    Input
    func terminate() {
        didFinish.accept(())
    }
}
