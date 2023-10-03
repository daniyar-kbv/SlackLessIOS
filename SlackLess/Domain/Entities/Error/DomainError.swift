//
//  DomainError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum DomainError: ErrorPresentable {
    case dataError(String)
    case general
    case request
    case cantMakeApplePayPayment
    case unsupportedApplePayPaymentMethods
    case updateLockFailed

    var presentationDescription: String {
        switch self {
        case let .dataError(message): return message
        case .general: return SLTexts.Error.Domain.general.localized()
        case .request: return SLTexts.Error.Domain.request.localized()
        case .cantMakeApplePayPayment: return SLTexts.Error.Domain.cantMakeApplePayPayment.localized()
        case .unsupportedApplePayPaymentMethods: return SLTexts.Error.Domain.unsupportedApplePayPaymentMethods.localized()
        case .updateLockFailed: return SLTexts.Error.Domain.updateLockFailed.localized()
        }
    }
}
