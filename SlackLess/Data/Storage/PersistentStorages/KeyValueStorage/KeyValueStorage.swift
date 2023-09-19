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

enum KeyValueStorageKey: String, StorageKey, Equatable {
    case appLocale
    case onbardingShown
    case selectedApps
    case timeLimit
    case startDate
    case progressDate

    public var value: String { return rawValue }
}

protocol KeyValueStorage {
    var appLocale: Language { get }
    var onbardingShown: Bool { get }
    var startDate: Date? { get }
    var progressDate: Date? { get }
    var progressDateObservable: PublishRelay<Date?> { get }
    func getSelectedApps(for date: Date) -> FamilyActivitySelection?
    func getTimeLimit(for date: Date) -> TimeInterval

    func persist(appLocale: Language)
    func persist(onbardingShown: Bool)
    func persist(selectedApps: FamilyActivitySelection, for date: Date)
    func persist(timeLimit: TimeInterval, for date: Date)
    func persist(startDate: Date)
    func persist(progressDate: Date)

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
    }

    var onbardingShown: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.onbardingShown.value)
    }

    var appLocale: Language {
        Language.get(by: storageProvider.string(forKey: KeyValueStorageKey.appLocale.value))
    }

    var startDate: Date? {
        storageProvider.object(forKey: KeyValueStorageKey.startDate.value) as? Date
    }

    var progressDate: Date? {
        storageProvider.object(forKey: KeyValueStorageKey.progressDate.value) as? Date
    }

    let progressDateObservable = PublishRelay<Date?>()

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

    func persist(appLocale: Language) {
        storageProvider.set(appLocale.code, forKey: KeyValueStorageKey.appLocale.value)
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

    func persist(startDate: Date) {
        storageProvider.set(startDate, forKey: KeyValueStorageKey.startDate.value)
    }

    func persist(progressDate: Date) {
        storageProvider.set(progressDate, forKey: KeyValueStorageKey.progressDate.value)
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
