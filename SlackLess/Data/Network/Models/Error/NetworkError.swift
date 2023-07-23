//
//  NetworkError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

// Tech debt: Refactor

import Foundation

protocol ErrorPresentable: Error {
    var presentationDescription: String { get }
}

enum NetworkError: ErrorPresentable, Equatable {
    case badMapping
    case noData
    case error(String)

    var presentationDescription: String {
        switch self {
        case .badMapping: return SLTexts.Error.Data.badMapping.localized()
        case .noData: return SLTexts.Error.Data.noData.localized()
        case let .error(message): return message
        }
    }
}

struct ErrorResponseDTO: Codable, ErrorPresentable {
    let code: String
    let message: String

    var presentationDescription: String {
        #if DEBUG
            return code
        #else
            return message
        #endif
    }
}

extension ErrorResponseDTO {
    func toDomainEntity() -> DomainErrorResponse {
        return .init(code: code, message: message)
    }
}
