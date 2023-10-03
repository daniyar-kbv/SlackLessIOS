//
//  KeyValueStorage.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import FamilyControls
import Foundation
import RxCocoa
import RxSwift

//  TODO: Make all observable

enum KeyValueStorageKey: String, StorageKey, Equatable {
    case onbardingShown
    case selectedApps
    case timeLimit
    case unlockedTime
    case unlockPrice
    case isLocked
    case startDate
    case progressDate
    case currentWeek
    case shieldState

    public var value: String { return rawValue }
}

protocol KeyValueStorage {
    var onbardingShown: Bool { get }
    var unlockPrice: Double { get }
    var isLocked: Bool { get }
    var isLockedObservable: PublishRelay<Bool> { get }
    var startDate: Date? { get }
    var progressDate: Date? { get }
    var progressDateObservable: PublishRelay<Date?> { get }
    var currentWeek: Date? { get }
    var shieldState: SLShieldState { get }
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getTimeLimit(for date: Date) -> TimeInterval
    func getUnlockedTime(for date: Date) -> TimeInterval

    func persist(onbardingShown: Bool)
    func persist(selectedApps: FamilyActivitySelection, for date: Date)
    func persist(timeLimit: TimeInterval, for date: Date)
    func persist(unlockedTime: TimeInterval, for date: Date)
    func persist(unlockPrice: Double)
    func persist(isLocked: Bool)
    func persist(startDate: Date)
    func persist(progressDate: Date)
    func persist(currentWeek: Date)
    func persist(shieldState: SLShieldState)

    func cleanUp(key: KeyValueStorageKey)
}

final class KeyValueStorageImpl: KeyValueStorage {
    private let disposeBag = DisposeBag()
    private let storageProvider: UserDefaults = .init(suiteName: Constants.UserDefaults.SuiteName.main) ?? .standard
    private let decoder = PropertyListDecoder()

    public init() {
        bind()
    }

    private func bind() {
        storageProvider.rx
            .observe(Date.self, KeyValueStorageKey.progressDate.value)
            .debounce(.milliseconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(to: progressDateObservable)
            .disposed(by: disposeBag)

        storageProvider.rx
            .observe(Bool.self, KeyValueStorageKey.isLocked.value)
            .debounce(.milliseconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                self?.isLockedObservable.accept($0 ?? false)
            })
            .disposed(by: disposeBag)
    }

    var onbardingShown: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.onbardingShown.value)
    }

    var unlockPrice: Double {
        storageProvider.double(forKey: KeyValueStorageKey.unlockPrice.value)
    }

    var isLocked: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.isLocked.value)
    }

    lazy var isLockedObservable: PublishRelay<Bool> = .init()

    var startDate: Date? {
        storageProvider.object(forKey: KeyValueStorageKey.startDate.value) as? Date
    }

    var progressDate: Date? {
        storageProvider.object(forKey: KeyValueStorageKey.progressDate.value) as? Date
    }

    let progressDateObservable: PublishRelay<Date?> = .init()

    var currentWeek: Date? {
        storageProvider.object(forKey: KeyValueStorageKey.currentWeek.value) as? Date
    }
    
    var shieldState: SLShieldState {
        .init(rawValue: storageProvider.object(forKey: KeyValueStorageKey.shieldState.value) as? Int)
    }

    //  TODO: Refactor with DB

    func getSelectedApps(for date: Date) -> FamilyActivitySelection? {
        guard let data = storageProvider.data(forKey: KeyValueStorageKey.selectedApps.value + makeString(from: date))
        else { return nil }

        let object = try? decoder.decode(
            FamilyActivitySelection.self,
            from: data
        )

        return object
    }

    func getTimeLimit(for date: Date) -> TimeInterval {
        storageProvider.double(forKey: KeyValueStorageKey.timeLimit.value + makeString(from: date))
    }

    func getUnlockedTime(for date: Date) -> TimeInterval {
        storageProvider.double(forKey: KeyValueStorageKey.unlockedTime.value + makeString(from: date))
    }

    func persist(onbardingShown: Bool) {
        storageProvider.set(onbardingShown, forKey: KeyValueStorageKey.onbardingShown.value)
    }

    func persist(selectedApps: FamilyActivitySelection, for date: Date) {
        let encoder = PropertyListEncoder()

        storageProvider.set(
            try? encoder.encode(selectedApps),
            forKey: KeyValueStorageKey.selectedApps.value + makeString(from: date)
        )
    }

    func persist(timeLimit: TimeInterval, for date: Date) {
        storageProvider.set(timeLimit, forKey: KeyValueStorageKey.timeLimit.value + makeString(from: date))
    }

    func persist(unlockedTime: TimeInterval, for date: Date) {
        storageProvider.set(unlockedTime, forKey: KeyValueStorageKey.unlockedTime.value + makeString(from: date))
    }

    func persist(unlockPrice: Double) {
        storageProvider.set(unlockPrice, forKey: KeyValueStorageKey.unlockPrice.value)
    }

    func persist(isLocked: Bool) {
        storageProvider.set(isLocked, forKey: KeyValueStorageKey.isLocked.value)
    }

    func persist(startDate: Date) {
        storageProvider.set(startDate, forKey: KeyValueStorageKey.startDate.value)
    }

    func persist(progressDate: Date) {
        storageProvider.set(progressDate, forKey: KeyValueStorageKey.progressDate.value)
    }

    func persist(currentWeek: Date) {
        storageProvider.set(currentWeek, forKey: KeyValueStorageKey.currentWeek.value)
    }
    
    func persist(shieldState: SLShieldState) {
        storageProvider.set(shieldState.rawValue, forKey: KeyValueStorageKey.shieldState.value)
    }

    func cleanUp(key: KeyValueStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
}

extension KeyValueStorageImpl {
    func makeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: date)
    }
}
