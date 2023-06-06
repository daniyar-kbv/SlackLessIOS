//
//  AlertDisplayable.swift
//  SlackLess
//
//  Created by Dan on 23.08.2021.
//

import UIKit

protocol AlertDisplayable: AnyObject {
    func showError(_ error: ErrorPresentable, completion: (() -> Void)?)
    func showAlert(title: String, message: String?, submitTitle: String, completion: (() -> Void)?)
    func showAlert(title: String, message: String?, actions: [UIAlertAction])
}

extension UIViewController: AlertDisplayable {
    func showError(_ error: ErrorPresentable, completion: (() -> Void)?) {
        showAlert(title: SLTexts.Alert.Error.title.localized(),
                  message: error.presentationDescription,
                  submitTitle: SLTexts.Alert.Action.defaultTitle.localized(),
                  completion: completion)
    }

    func showAlert(title: String, message: String?, submitTitle: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: submitTitle, style: .default) { _ in
            completion?()
        }

        alertController.addAction(action)

        present(alertController, animated: true)
    }

    func showAlert(title: String, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions.forEach { alertController.addAction($0) }

        present(alertController, animated: true)
    }
}
