//
//  ReactiveExtension.swift
//  SlackLess
//
//  Created by Abzal Toremuratuly on 01.05.2021.
//

import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: UITableView {
    var reload: Binder<Void?> {
        return Binder(base, binding: {
            guard let _ = $1 else { return }
            $0.reloadData()
        })
    }
}

public extension Reactive where Base: UICollectionView {
    var reload: Binder<Void?> {
        return Binder(base, binding: {
            guard let _ = $1 else { return }
            $0.reloadData()
        })
    }
}
