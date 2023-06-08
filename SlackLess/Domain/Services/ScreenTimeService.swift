//
//  ScreenTimeService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-07.
//

import Foundation
import RxSwift
import RxCocoa

protocol ScreenTimeServiceInput {
    func getAppsInfo()
}

protocol ScreenTimeServiceOutput {
    var appsInfo: PublishRelay<[AppInfo]> { get }
}

protocol ScreenTimeService: AnyObject {
    var input: ScreenTimeServiceInput { get }
    var output: ScreenTimeServiceOutput { get }
}

final class ScreenTimeServiceImpl: ScreenTimeService, ScreenTimeServiceInput, ScreenTimeServiceOutput {
    var input: ScreenTimeServiceInput { self }
    var output: ScreenTimeServiceOutput { self }
    
    //    Output
    var appsInfo: PublishRelay<[AppInfo]> = .init()
    
    //    Input
    func getAppsInfo() {
        var lastNumber = 3600
        appsInfo.accept((0..<11).map({ _ in
            let seconds = Int.random(in: Range(uncheckedBounds: (lower: lastNumber*Int(0.8), upper: lastNumber)))
            lastNumber = seconds
            return AppInfo(name: "SlackLess", image: SLImages.appIcon.getImage()?.pngData(), time: seconds)
        }))
    }
}
