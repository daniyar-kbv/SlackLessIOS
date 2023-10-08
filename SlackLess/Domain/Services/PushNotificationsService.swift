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
}

protocol PushNotificationsServiceOutput: AnyObject {
    var receivedNotification: PublishRelay<SLPushNotification> { get }
    var errorOccured: PublishRelay<ErrorPresentable> { get }
}

protocol PushNotificationsService: AnyObject {
    var input: PushNotificationsServiceInput { get }
    var output: PushNotificationsServiceOutput { get }
}

final class PushNotificationsServiceImpl: NSObject, PushNotificationsService, PushNotificationsServiceInput, PushNotificationsServiceOutput {
    var input: PushNotificationsServiceInput { self }
    var output: PushNotificationsServiceOutput { self }
    
    let center = UNUserNotificationCenter.current()
    var notifications: [SLPushNotificationType] = []
    
    override init() {
        super.init()
        
        center.delegate = self
    }
    
    //    Output
    var receivedNotification: PublishRelay<SLPushNotification> = .init()
    let errorOccured: PublishRelay<ErrorPresentable> = .init()
    
    //    Input
    func configure() {
        center.getNotificationSettings() { [weak self] notificationSettings in
            guard let self = self else { return }
            switch notificationSettings.authorizationStatus {
            case .authorized:
                center.removeAllPendingNotificationRequests()
                notifications.forEach({ self.scheduleNotification(of: $0) })
            case .notDetermined:
                requestAuthorization(onCompletion: self.configure)
            default: break
            }
        }
    }
}

extension PushNotificationsServiceImpl {
    private func requestAuthorization(onCompletion: @escaping (() -> Void)) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] authorized, error in
            if let error = error as? ErrorPresentable {
                self?.errorOccured.accept(error)
                return
            }
            
            onCompletion()
        }
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
