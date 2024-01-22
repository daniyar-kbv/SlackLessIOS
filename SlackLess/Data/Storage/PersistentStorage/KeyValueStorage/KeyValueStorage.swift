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

enum KeyValueStorageKey: String, StorageKey, Equatable, CaseIterable {
    case onbardingShown
    case dayData
//    TODO: Move to DayData
    case unlockedTime
    case unlockPrice
    case isLocked
    case startDate
    case progressDate
    case currentWeek
    case shieldState
    case pushNotificationsEnabled
    case purchasedTokens
    case usedTokens

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
    var pushNotificationsEnabled: Bool { get }
    var purchasedTokens: Int { get }
    var usedTokens: Int { get }
    func getDayData(for date: Date) -> DayData?
    func getUnlockedTime(for date: Date) -> TimeInterval

    func persist(onbardingShown: Bool)
    func persist(dayData: DayData)
    func persist(unlockedTime: TimeInterval, for date: Date)
    func persist(unlockPrice: Double)
    func persist(isLocked: Bool)
    func persist(startDate: Date)
    func persist(progressDate: Date)
    func persist(currentWeek: Date)
    func persist(shieldState: SLShieldState)
    func persist(pushNotificationsEnabled: Bool)
    func persist(purchasedTokens: Int)
    func persist(usedTokens: Int)

    func cleanUp(key: KeyValueStorageKey)
    func cleanUp()
}

final class KeyValueStorageImpl: KeyValueStorage {
    private let disposeBag = DisposeBag()
    private let storageProvider: UserDefaults = .init(suiteName: Constants.SharedStorage.appGroup) ?? .standard
    private let encoder = PropertyListEncoder()
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
    
    var pushNotificationsEnabled: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.pushNotificationsEnabled.value)
    }
    
    var purchasedTokens: Int {
        storageProvider.integer(forKey: KeyValueStorageKey.purchasedTokens.value)
    }
    
    var usedTokens: Int {
        storageProvider.integer(forKey: KeyValueStorageKey.usedTokens.value)
    }
    
//    TODO: Move to repository
    func getDayData(for date: Date) -> DayData? {
        guard let data = storageProvider.data(forKey: KeyValueStorageKey.dayData.value)
        else { return nil }

        let objects = try? decoder.decode(
            [DayData].self,
            from: data
        )
        
        return objects?.filter({ $0.date <= date.getDate() }).sorted(by: { $0.date > $1.date }).first
    }

    func getUnlockedTime(for date: Date) -> TimeInterval {
        storageProvider.double(forKey: KeyValueStorageKey.unlockedTime.value + makeString(from: date))
    }

    func persist(onbardingShown: Bool) {
        storageProvider.set(onbardingShown, forKey: KeyValueStorageKey.onbardingShown.value)
    }

    func persist(unlockedTime: TimeInterval, for date: Date) {
        storageProvider.set(unlockedTime, forKey: KeyValueStorageKey.unlockedTime.value + makeString(from: date))
    }
    
//    TODO: Move to repository
    func persist(dayData: DayData) {
        var dayData = dayData
        dayData.date = dayData.date.getDate()
        
        var objects = [DayData]()
        
        if let data = storageProvider.data(forKey: KeyValueStorageKey.dayData.value) {
            objects = (try? decoder.decode([DayData].self, from: data)) ?? []
        }
        
        if let index = objects.firstIndex(where: { $0.date == dayData.date }) {
            objects.remove(at: index)
            objects.insert(dayData, at: index)
        } else {
            objects.append(dayData)
            objects.sort(by: { $0.date > $1.date })
        }
        
        storageProvider.set(
            try? encoder.encode(objects),
            forKey: KeyValueStorageKey.dayData.value
        )
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
    
    func persist(pushNotificationsEnabled: Bool) {
        storageProvider.set(pushNotificationsEnabled, forKey: KeyValueStorageKey.pushNotificationsEnabled.value)
    }
    
    func persist(purchasedTokens: Int) {
        storageProvider.set(purchasedTokens, forKey: KeyValueStorageKey.purchasedTokens.value)
    }
    
    func persist(usedTokens: Int) {
        storageProvider.set(usedTokens, forKey: KeyValueStorageKey.usedTokens.value)
    }

    func cleanUp(key: KeyValueStorageKey) {
        storageProvider.set(nil, forKey: key.value)
    }
    
    func cleanUp() {
        storageProvider.removePersistentDomain(forName: Constants.SharedStorage.appGroup)
        storageProvider.synchronize()
    }
}

extension KeyValueStorageImpl {
    func makeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: date)
    }
}
