//
//  LeaderManager.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import SnapKit

// Tech debt: refactor or remove

protocol LoaderManager: AnyObject {
    func showLoader()
    func hideLoader()
}

final class LoaderManagerImpl: LoaderManager {
    private let loaderView = LoaderView()

    func showLoader() {
//        DispatchQueue.main.async { [weak self] in
//            guard let window = UIApplication.shared.keyWindow else { return }
//            self?.loaderView.showLoader(on: window)
//        }
    }

    func hideLoader() {
        loaderView.hideLoader()
    }
}
