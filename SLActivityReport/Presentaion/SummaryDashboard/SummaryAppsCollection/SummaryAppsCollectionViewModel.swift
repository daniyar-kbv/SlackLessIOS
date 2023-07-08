//
//  SummaryAppsCollectionViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol SummaryAppsCollectionViewModelInput {
}

protocol SummaryAppsCollectionViewModelOutput {
    func getNumberOfItems() -> Int
    func getAppInfoItem(for: Int) -> AppInfo
    func getAppTimeLength(for: Int) -> Float
}

protocol SummaryAppsCollectionViewModel: AnyObject {
    var input: SummaryAppsCollectionViewModelInput { get }
    var output: SummaryAppsCollectionViewModelOutput { get }
}

final class SummaryAppsCollectionViewModelImpl: SummaryAppsCollectionViewModel, SummaryAppsCollectionViewModelInput, SummaryAppsCollectionViewModelOutput {
    var input: SummaryAppsCollectionViewModelInput { self }
    var output: SummaryAppsCollectionViewModelOutput { self }
    
    private let disposeBag = DisposeBag()
    private let appsInfo: [AppInfo]
    
    private lazy var appTimes: (min: Int?, max: Int?) = {
        return (appsInfo.map({ $0.time }).min(), appsInfo.map({ $0.time }).max())
    }()
    
    init(appsInfo: [AppInfo]) {
        self.appsInfo = appsInfo
    }

    //    Input
    func getData() {
//        screenTimeService.input.getAppsInfo()
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
    
    func getAppInfoItem(for index: Int) -> AppInfo {
        appsInfo[index]
    }
    
    func getAppTimeLength(for index: Int) -> Float {
        guard let min = appTimes.min,
                let max = appTimes.max
        else { return 0 }
        
        return 0.2+(Float(appsInfo[index].time-min)/Float(max-min)*0.8)
    }
}
