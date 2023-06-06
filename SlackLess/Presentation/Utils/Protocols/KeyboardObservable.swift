//
//  KeyboardObservable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol KeyboardObservable: AnyObject {
    var disposeBag: DisposeBag { get set }

    func observeKeyboard(onShow: ((_ norification: Notification) -> Void)?,
                         onHide: ((_ norification: Notification) -> Void)?)
    func stopObservingKeyboard()
}

extension KeyboardObservable where Self: UIViewController {
    func observeKeyboard(onShow: ((_ norification: Notification) -> Void)?,
                         onHide: ((_ norification: Notification) -> Void)?)
    {
        NotificationCenter.default
            .rx
            .notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: onShow)
            .disposed(by: disposeBag)

        NotificationCenter.default
            .rx
            .notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: onHide)
            .disposed(by: disposeBag)
    }

    func stopObservingKeyboard() {
        disposeBag = DisposeBag()
    }
}
