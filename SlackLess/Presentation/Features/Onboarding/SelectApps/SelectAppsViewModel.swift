//
//  SelectAppsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectAppsViewModelInput {
    func close()
}

protocol SelectAppsViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
}

protocol SelectAppsViewModel: AnyObject {
    var input: SelectAppsViewModelInput { get }
    var output: SelectAppsViewModelOutput { get }
}

final class SelectAppsViewModelImpl: SelectAppsViewModel, SelectAppsViewModelInput, SelectAppsViewModelOutput {
    var input: SelectAppsViewModelInput { self }
    var output: SelectAppsViewModelOutput { self }
    
    //    Output
    var didFinish: PublishRelay<Void> = .init()
    
    //    Input
    func close() {
        didFinish.accept(())
    }
}
