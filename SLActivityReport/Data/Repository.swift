//
//  Repository.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-11-30.
//

import Foundation
import FamilyControls
import RxSwift
import RxCocoa

protocol Repository: AnyObject {
    var progressDate: BehaviorRelay<Date?> { get }
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getTimeLimit(for date: Date) -> TimeInterval?
}

final class RepositoryImpl: Repository {
    private let keyValueStorage: KeyValueStorage
    private let disposeBag = DisposeBag()
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
        
        progressDate = .init(value: keyValueStorage.progressDate)
        
        keyValueStorage.progressDateObservable
            .bind(to: progressDate)
            .disposed(by: disposeBag)
    }
    
    var progressDate: BehaviorRelay<Date?>
    
    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        keyValueStorage.getSelectedApps(for: date)
    }
    
    func getTimeLimit(for date: Date) -> TimeInterval? {
        keyValueStorage.getTimeLimit(for: date)
    }
}
