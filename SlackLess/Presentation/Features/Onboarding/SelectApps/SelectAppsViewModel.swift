//
//  SelectAppsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-24.
//

import Foundation
import RxSwift
import RxCocoa
import FamilyControls

protocol SelectAppsViewModelInput {
    func close()
    func save(appsSelection: FamilyActivitySelection)
}

protocol SelectAppsViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
    var appsSelected: PublishRelay<Void> { get }
}

protocol SelectAppsViewModel: AnyObject {
    var input: SelectAppsViewModelInput { get }
    var output: SelectAppsViewModelOutput { get }
}

final class SelectAppsViewModelImpl: SelectAppsViewModel, SelectAppsViewModelInput, SelectAppsViewModelOutput {
    private let screenTimeService: ScreenTimeService
    
    var input: SelectAppsViewModelInput { self }
    var output: SelectAppsViewModelOutput { self }
    
    init(screenTimeService: ScreenTimeService) {
        self.screenTimeService = screenTimeService
    }
    
    //    Output
    var didFinish: PublishRelay<Void> = .init()
    var appsSelected: PublishRelay<Void> = .init()
    
    //    Input
    func close() {
        didFinish.accept(())
    }
    
    func save(appsSelection: FamilyActivitySelection) {
        screenTimeService.input.save(appsSelection: appsSelection)
    }
}
