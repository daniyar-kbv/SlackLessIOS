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
    case startDate
    case progressDate
    case currentWeek
    case shield
    case pushNotificationsEnabled

    public var value: String { return rawValue }
}

protocol KeyValueStorage {
    var onbardingShown: Bool { get }
    var unlockPrice: Double { get }
    var startDate: Date? { get }
    var progressDate: Date? { get }
    var progressDateObservable: PublishRelay<Date?> { get }
    var currentWeek: Date? { get }
    var shield: SLShield? { get }
    var pushNotificationsEnabled: Bool { get }
    func getDayData(for date: Date) -> DayData?
    func getUnlockedTime(for date: Date) -> TimeInterval

    func persist(onbardingShown: Bool)
    func persist(dayData: DayData)
    func persist(unlockedTime: TimeInterval, for date: Date)
    func persist(unlockPrice: Double)
    func persist(startDate: Date)
    func persist(progressDate: Date)
    func persist(currentWeek: Date)
    func persist(shield: SLShield)
    func persist(pushNotificationsEnabled: Bool)

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
    }

    var onbardingShown: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.onbardingShown.value)
    }

    var unlockPrice: Double {
        storageProvider.double(forKey: KeyValueStorageKey.unlockPrice.value)
    }

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
    
    var shield: SLShield? {
        guard let data = storageProvider.data(forKey: KeyValueStorageKey.shield.value)
        else { return nil }

        return try? decoder.decode(
            SLShield.self,
            from: data
        )
    }
    
    var pushNotificationsEnabled: Bool {
        storageProvider.bool(forKey: KeyValueStorageKey.pushNotificationsEnabled.value)
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

    func persist(startDate: Date) {
        storageProvider.set(startDate, forKey: KeyValueStorageKey.startDate.value)
    }

    func persist(progressDate: Date) {
        storageProvider.set(progressDate, forKey: KeyValueStorageKey.progressDate.value)
    }

    func persist(currentWeek: Date) {
        storageProvider.set(currentWeek, forKey: KeyValueStorageKey.currentWeek.value)
    }
    
    func persist(shield: SLShield) {
        storageProvider.set(
            try? encoder.encode(shield),
            forKey: KeyValueStorageKey.shield.value
        )
    }
    
    func persist(pushNotificationsEnabled: Bool) {
        storageProvider.set(pushNotificationsEnabled, forKey: KeyValueStorageKey.pushNotificationsEnabled.value)
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
