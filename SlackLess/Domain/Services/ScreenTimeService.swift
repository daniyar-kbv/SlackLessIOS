//
//  ScreenTimeService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-07.
//

import Foundation
import RxSwift
import RxCocoa
import FamilyControls
import SwiftUI

protocol ScreenTimeServiceInput {
    func requestAuthorization()
    func save(appsSelection: FamilyActivitySelection)
}

protocol ScreenTimeServiceOutput {
    var authorizaionStatus: PublishRelay<Result<Void, Error>> { get }
    var appsSelectionSaved: PublishRelay<Void> { get }
}

protocol ScreenTimeService: AnyObject {
    var input: ScreenTimeServiceInput { get }
    var output: ScreenTimeServiceOutput { get }
}

final class ScreenTimeServiceImpl: ScreenTimeService, ScreenTimeServiceInput, ScreenTimeServiceOutput {
    private let keyValueStorage: KeyValueStorage
    
    var input: ScreenTimeServiceInput { self }
    var output: ScreenTimeServiceOutput { self }
    
    private let center = AuthorizationCenter.shared
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
    }
    
    //    Output
    var authorizaionStatus: PublishRelay<Result<Void, Error>> = .init()
    var appsSelectionSaved: PublishRelay<Void> = .init()
    
    //    Input
    func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
                DispatchQueue.main.async { [weak self] in
                    self?.authorizaionStatus.accept(.success(()))
                }
            } catch {
                authorizaionStatus.accept(.failure(DomainEmptyError()))
            }
        }
    }
    
    func save(appsSelection: FamilyActivitySelection) {
        keyValueStorage.persist(selectedApps: appsSelection)
        appsSelectionSaved.accept(())
    }
}
