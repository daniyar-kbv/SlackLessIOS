//
//  SLAppsCollectionViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-07.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SLAppsCollectionViewModelInput {
    func terminate()
}

protocol SLAppsCollectionViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
    
    func getNumberOfItems() -> Int
    func getAppInfoItem(for: Int) -> AppInfoUI
    func getAppTimeLength(for: Int) -> Float
}

protocol SLAppsCollectionViewModel: AnyObject {
    var input: SLAppsCollectionViewModelInput { get }
    var output: SLAppsCollectionViewModelOutput { get }
}

//final class SLAppsCollectionViewModelImpl: SLAppsCollectionViewModel, SLAppsCollectionViewModelInput, SLAppsCollectionViewModelOutput {
//    var input: SLAppsCollectionViewModelInput { self }
//    var output: SLAppsCollectionViewModelOutput { self }
//
//    //    Output
//    var didFinish: PublishRelay<Void> = .init()
//
//    //    Input
//    func terminate() {
//        didFinish.accept(())
//    }
//}
