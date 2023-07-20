//
//  ITunesService.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation
import RxSwift
import RxCocoa

protocol ITunesServiceInput {
    
}

protocol ITunesServiceOutput {
    func getIconURL(for appName: String, _ onCompletion: @escaping (URL) -> Void)
}

protocol ITunesService: AnyObject {
    var input: ITunesServiceInput { get }
    var output: ITunesServiceOutput { get }
}

final class ITunesServiceImpl: ITunesService, ITunesServiceInput, ITunesServiceOutput {
    var input: ITunesServiceInput { self }
    var output: ITunesServiceOutput { self }
    
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
