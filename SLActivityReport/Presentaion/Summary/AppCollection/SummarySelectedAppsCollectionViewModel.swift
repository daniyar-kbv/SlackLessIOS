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
    func update(apps: [ARApp])
}

protocol SummaryAppsCollectionViewModelOutput {
    var appsChanged: PublishRelay<Void> { get }
    
    func getNumberOfApps() -> Int
    func getApp(for: Int) -> ARApp
    func getAppRatio(for: Int) -> CGFloat
}

protocol SummaryAppsCollectionViewModel: AnyObject {
    var input: SummaryAppsCollectionViewModelInput { get }
    var output: SummaryAppsCollectionViewModelOutput { get }
}

final class SummaryAppsCollectionViewModelImpl: SummaryAppsCollectionViewModel, SummaryAppsCollectionViewModelInput, SummaryAppsCollectionViewModelOutput {
    var input: SummaryAppsCollectionViewModelInput { self }
    var output: SummaryAppsCollectionViewModelOutput { self }
    
    private var apps: [ARApp]
    
    init(apps: [ARApp]) {
        self.apps = apps
    }

    //    Input
    
    func update(apps: [ARApp]) {
        self.apps = apps
        appsChanged.accept(())
    }
    
    //    Output
    let appsChanged: PublishRelay<Void> = .init()
    
    func getNumberOfApps() -> Int {
        return apps.count
    }
    
    func getApp(for index: Int) -> ARApp {
        apps[index]
    }
    
    func getAppRatio(for index: Int) -> CGFloat {
        guard let min = apps.map({ $0.time }).min(),
                let max = apps.map({ $0.time }).max()
        else { return 0 }
        
        return CGFloat(apps[index].time-min)/CGFloat(max-min)
    }
}
