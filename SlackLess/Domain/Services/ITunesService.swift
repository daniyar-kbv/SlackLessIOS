//
//  AppInfoService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation
import RxSwift
import RxCocoa

protocol AppInfoServiceInput {
    
}

protocol AppInfoServiceOutput {
    func getIconURL(for appName: String, _ onCompletion: @escaping (URL) -> Void)
}

protocol AppInfoService: AnyObject {
    var input: AppInfoServiceInput { get }
    var output: AppInfoServiceOutput { get }
}

final class AppInfoServiceImpl: AppInfoService, AppInfoServiceInput, AppInfoServiceOutput {
    var input: AppInfoServiceInput { self }
    var output: AppInfoServiceOutput { self }
    
    private let disposeBag = DisposeBag()
    private let iTunesAPI: ITunesAPI
    
    init(iTunesAPI: ITunesAPI) {
        self.iTunesAPI = iTunesAPI
    }
    
    //    Output
    
    func getIconURL(for appName: String, _ onCompletion: @escaping (URL) -> Void) {
        iTunesAPI.search(by: appName).subscribe(
        onSuccess: {
            guard let result = $0.results.first,
                  let iconURLString = result.iconURL ,
                  let iconURL = URL(string: iconURLString)
            else { return }
            onCompletion(iconURL)
        })
        .disposed(by: disposeBag)
    }
    
    //    Input
}
