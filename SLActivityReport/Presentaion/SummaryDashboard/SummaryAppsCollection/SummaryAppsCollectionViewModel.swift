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
    func getAppTimeRatio(for: Int) -> CGFloat
    func getMaxTime() -> Int?
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
    
    func getAppTimeRatio(for index: Int) -> CGFloat {
        guard let min = appsInfo.map({ $0.time }).min(),
                let max = appsInfo.map({ $0.time }).max()
        else { return 0 }
        
        return CGFloat(appsInfo[index].time-min)/CGFloat(max-min)
    }
    
    func getMaxTime() -> Int? {
        return appsInfo.map({ $0.time }).max()
    }
}
