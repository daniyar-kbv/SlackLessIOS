//
//  DomainError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

struct DomainErrorResponse: ErrorPresentable {
    let code: String
    let message: String

    var presentationDescription: String { return message }
}

enum DomainError: ErrorPresentable {
    case request

    var presentationDescription: String {
        switch self {
        case .request: return SLTexts.Error.Domain.request.localized()
        }
    }
}
