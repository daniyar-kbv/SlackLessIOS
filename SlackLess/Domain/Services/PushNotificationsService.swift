//
//  PushNotificationsService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-04.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

protocol PushNotificationsServiceInput: AnyObject {
    func configure()
    func getPushNotificationsEnabled()
    func set(pushNotificationsEnabled: Bool)
}

protocol PushNotificationsServiceOutput: AnyObject {
    var receivedNotification: PublishRelay<SLPushNotification> { get }
    var pushNotificationEnabled: PublishRelay<Bool> { get }
    var pushNotificationsUnauthorized: PublishRelay<Void> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
}

protocol PushNotificationsService: AnyObject {
    var input: PushNotificationsServiceInput { get }
    var output: PushNotificationsServiceOutput { get }
}

final class PushNotificationsServiceImpl: NSObject, PushNotificationsService, PushNotificationsServiceInput, PushNotificationsServiceOutput {
    var input: PushNotificationsServiceInput { self }
    var output: PushNotificationsServiceOutput { self }
    
    let appSettingsRepository: AppSettingsRepository
    
    let center = UNUserNotificationCenter.current()
    var notifications: [SLPushNotificationType] = []
    
    init(appSettingsRepository: AppSettingsRepository) {
        self.appSettingsRepository = appSettingsRepository
        
        super.init()
        
        center.delegate = self
    }
    
    //    Output
    let receivedNotification: PublishRelay<SLPushNotification> = .init()
    let pushNotificationEnabled: PublishRelay<Bool> = .init()
    let pushNotificationsUnauthorized: PublishRelay<Void> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    
    //    Input
    func configure() {
        center.getNotificationSettings() { [weak self] notificationSettings in
            guard let self = self else { return }
            switch notificationSettings.authorizationStatus {
            case .authorized:
                guard appSettingsRepository.output.getPushNotificationsEnabled() else { break }
                rescheduleNotifications()
            case .notDetermined:
                requestAuthorization(onCompletion: self.configure)
            default: break
            }
        }
    }
    
    func getPushNotificationsEnabled() {
        Task {
            guard await isAuthorized() else {
                DispatchQueue.main.async { [weak self] in
                    self?.pushNotificationEnabled.accept(false)
                }
                return
            }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                pushNotificationEnabled.accept(appSettingsRepository.output.getPushNotificationsEnabled())
            }
        }
    }
    
    func set(pushNotificationsEnabled: Bool) {
        Task {
            if pushNotificationsEnabled {
                guard await isAuthorized() else {
                    DispatchQueue.main.async { [weak self] in
                        self?.pushNotificationEnabled.accept(false)
                        self?.pushNotificationsUnauthorized.accept(())
                    }
                    return
                }
                rescheduleNotifications()
            } else {
                discardNotifications()
            }
            
            appSettingsRepository.input.set(pushNotificationsEnabled: pushNotificationsEnabled)
        }
    }
}

extension PushNotificationsServiceImpl {
    private func requestAuthorization(onCompletion: @escaping (() -> Void)) {
        appSettingsRepository.input.set(pushNotificationsEnabled: true)
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] authorized, error in
            if let error = error as? ErrorPresentable {
                self?.errorOccured.accept(error)
                return
            }

            onCompletion()
        }
    }
    
    private func isAuthorized() async -> Bool {
        let settings = await center.notificationSettings()
        return settings.authorizationStatus == .authorized
    }
    
    private func discardNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    private func rescheduleNotifications() {
        center.removeAllPendingNotificationRequests()
        notifications.forEach({ self.scheduleNotification(of: $0) })
    }
    
    private func scheduleNotification(of type: SLPushNotificationType) {
        center.add(type.makeRequest()) { [weak self] in
            if let error = $0 as? ErrorPresentable {
                self?.errorOccured.accept(error)
            }
        }
    }
}

extension PushNotificationsServiceImpl: UNUserNotificationCenterDelegate {
//  Notification recieved in foreground
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler _: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let notificationType = SLPushNotificationType(notification: notification) else { return }
        receivedNotification.accept(.init(type: notificationType, state: .foreground))
    }

//  Notification recieved in background
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler _: @escaping () -> Void) {
        guard let notificationType = SLPushNotificationType(notification: response.notification) else { return }
        receivedNotification.accept(.init(type: notificationType, state: .background))
    }
}
