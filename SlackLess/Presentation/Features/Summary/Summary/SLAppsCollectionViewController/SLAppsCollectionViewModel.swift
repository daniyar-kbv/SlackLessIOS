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
    func getData()
    func terminate()
}

protocol SLAppsCollectionViewModelOutput {
    var didFinish: PublishRelay<Void> { get }
    var didGetData: PublishRelay<Void> { get }
    
    func getNumberOfItems() -> Int
    func getAppInfoItem(for: Int) -> AppInfoUI
    func getAppTimeLength(for: Int) -> Float
}

protocol SLAppsCollectionViewModel: AnyObject {
    var input: SLAppsCollectionViewModelInput { get }
    var output: SLAppsCollectionViewModelOutput { get }
}

final class SLAppsCollectionViewModelImpl: SLAppsCollectionViewModel, SLAppsCollectionViewModelInput, SLAppsCollectionViewModelOutput {
    var input: SLAppsCollectionViewModelInput { self }
    var output: SLAppsCollectionViewModelOutput { self }
    
    private let disposeBag = DisposeBag()
    private let screenTimeService: ScreenTimeService
    private var appsInfo: [AppInfoUI] = [] {
        didSet {
            didGetData.accept(())
        }
    }
    private lazy var appTimes: (min: Int?, max: Int?) = {
        return (appsInfo.map({ $0.time }).min(), appsInfo.map({ $0.time }).max())
    }()
    
    init(screenTimeService: ScreenTimeService) {
        self.screenTimeService = screenTimeService
        
        bindService()
    }

    //    Input
    func getData() {
        screenTimeService.input.getAppsInfo()
    }
    
    func terminate() {
        didFinish.accept(())
    }
    
    //    Output
    let didFinish: PublishRelay<Void> = .init()
    let didGetData: PublishRelay<Void> = .init()
    
    func getNumberOfItems() -> Int {
        return appsInfo.count
    }
    
    func getAppInfoItem(for index: Int) -> AppInfoUI {
        appsInfo[index]
    }
    
    func getAppTimeLength(for index: Int) -> Float {
        guard let min = appTimes.min,
                let max = appTimes.max
        else { return 0 }
        
        return 0.2+(Float(appsInfo[index].time-min)/Float(max-min)*0.8)
    }
}

extension SLAppsCollectionViewModelImpl {
    func bindService() {
        screenTimeService
            .output
            .appsInfo
            .subscribe(onNext: { [weak self] in
                self?.appsInfo = $0.map({ $0.toUI() })
            })
            .disposed(by: disposeBag)
    }
}
