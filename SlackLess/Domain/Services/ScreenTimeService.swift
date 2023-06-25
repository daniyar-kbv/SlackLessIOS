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

protocol ScreenTimeServiceInput {
    func requestAuthorization()
}

protocol ScreenTimeServiceOutput {
    var authorizaionStatus: PublishRelay<Result<Void, Error>> { get }
}

protocol ScreenTimeService: AnyObject {
    var input: ScreenTimeServiceInput { get }
    var output: ScreenTimeServiceOutput { get }
}

final class ScreenTimeServiceImpl: ScreenTimeService, ScreenTimeServiceInput, ScreenTimeServiceOutput {
    var input: ScreenTimeServiceInput { self }
    var output: ScreenTimeServiceOutput { self }
    
    private let center = AuthorizationCenter.shared
    
    //    Output
    var authorizaionStatus: PublishRelay<Result<Void, Error>> = .init()
    
    //    Input
    func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
                authorizaionStatus.accept(.success(()))
            } catch {
                authorizaionStatus.accept(.failure(DomainEmptyError()))
            }
        }
    }
}
