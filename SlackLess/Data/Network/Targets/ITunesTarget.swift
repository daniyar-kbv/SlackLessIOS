//
//  ITunesTarget.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Moya

enum ITunesTarget {
    case searchBy(name: String)
}

extension ITunesTarget: SLTargetType {
    var baseURL: URL {
        return Constants.URLs.ITunesAPI.search
    }

    var path: String {
        switch self {
        case .searchBy: return "/search"
        }
    }

    var method: Method {
        switch self {
        case .searchBy: return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .searchBy(name): return .requestParameters(parameters: ["term": name, "entity": "software"], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var sendAuthToken: Bool {
        switch self {
        default: return false
        }
    }
}
