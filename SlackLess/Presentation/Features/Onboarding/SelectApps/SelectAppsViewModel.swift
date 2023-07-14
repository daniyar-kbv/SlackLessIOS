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
    func set(selectedApps: FamilyActivitySelection)
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
    private let disposeBag = DisposeBag()
    private let appSettingsService: AppSettingsService
    
    var input: SelectAppsViewModelInput { self }
    var output: SelectAppsViewModelOutput { self }
    
    init(appSettingsService: AppSettingsService) {
        self.appSettingsService = appSettingsService
        
        bindService()
    }
    
    //    Output
    var didFinish: PublishRelay<Void> = .init()
    var appsSelected: PublishRelay<Void> = .init()
    
    //    Input
    func close() {
        didFinish.accept(())
    }
    
    func set(selectedApps: FamilyActivitySelection) {
        appSettingsService.input.set(selectedApps: selectedApps)
    }
    
    private func bindService() {
        appSettingsService.output.appsSelectionSaved
            .bind(to: output.appsSelected)
            .disposed(by: disposeBag)
    }
}
