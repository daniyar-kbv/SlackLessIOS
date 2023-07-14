//
//  SummaryAppsCollectionViewModel.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import UIKit

protocol SummaryAppsCollectionViewModelInput {
}

protocol SummaryAppsCollectionViewModelOutput {
    func getNumberOfApps() -> Int
    func getApp(for: Int) -> ActivityReportApp
    func getAppRatio(for: Int) -> CGFloat
}

protocol SummaryAppsCollectionViewModel: AnyObject {
    var input: SummaryAppsCollectionViewModelInput { get }
    var output: SummaryAppsCollectionViewModelOutput { get }
}

final class SummaryAppsCollectionViewModelImpl: SummaryAppsCollectionViewModel, SummaryAppsCollectionViewModelInput, SummaryAppsCollectionViewModelOutput {
    var input: SummaryAppsCollectionViewModelInput { self }
    var output: SummaryAppsCollectionViewModelOutput { self }
    
    private let appsInfo: [ActivityReportApp]
    
    init(appsInfo: [ActivityReportApp]) {
        self.appsInfo = appsInfo
    }

    //    Input
    
    //    Output
    
    func getNumberOfApps() -> Int {
        return appsInfo.count
    }
    
    func getApp(for index: Int) -> ActivityReportApp {
        appsInfo[index]
    }
    
    func getAppRatio(for index: Int) -> CGFloat {
        guard let min = appsInfo.map({ $0.time }).min(),
                let max = appsInfo.map({ $0.time }).max()
        else { return 0 }
        
        return CGFloat(appsInfo[index].time-min)/CGFloat(max-min)
    }
}
