//
//  ITunesAPI.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Moya
import RxCocoa
import RxSwift

protocol ITunesAPI {
    func search(by name: String) -> Single<ITunesSearchDTO>
}

final class ITunesAPIImpl: ITunesAPI {
    private let provider: MoyaProvider<ITunesTarget>

    init(provider: MoyaProvider<ITunesTarget>) {
        self.provider = provider
    }

    func search(by name: String) -> Single<ITunesSearchDTO> {
        provider.rx.request(.searchBy(name: name))
            .map {
                guard let response = try? $0.map(ITunesSearchDTO.self) else {
                    throw NetworkError.badMapping
                }

                return response
            }
    }
}
