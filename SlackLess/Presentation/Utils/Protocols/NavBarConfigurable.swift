//
//  NavBarConfigurable.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxSwift
import UIKit

enum NavBarButtonType {
    var image: UIImage? {
        switch self {}
    }
}

protocol NavBarConfigurable: AnyObject {
    func addButton(type: NavBarButtonType?, disposeBag: DisposeBag, onTap: @escaping () -> Void)
}

extension NavBarConfigurable where Self: UIViewController {
    func addButton(type: NavBarButtonType?, disposeBag: DisposeBag, onTap: @escaping () -> Void) {
        let view = UIButton()
        view.setBackgroundImage(type?.image,
                                for: .normal)

        view.rx
            .tap
            .subscribe(onNext: {
                onTap()
            })
            .disposed(by: disposeBag)

        navigationItem.rightBarButtonItem = .init(customView: view)
    }
}
