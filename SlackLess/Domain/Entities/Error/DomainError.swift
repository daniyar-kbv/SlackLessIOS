//
//  DomainError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum DomainError: ErrorPresentable {
    case error(String)
    case general
    case request
    case cantMakeApplePayPayment
    case unsupportedApplePayPaymentMethods
    case updateLockFailed
    case invalidEmail

    var presentationDescription: String {
        switch self {
        case let .error(message): return message
        case .general: return SLTexts.Error.Domain.general.localized()
        case .request: return SLTexts.Error.Domain.request.localized()
        case .cantMakeApplePayPayment: return SLTexts.Error.Domain.cantMakeApplePayPayment.localized()
        case .unsupportedApplePayPaymentMethods: return SLTexts.Error.Domain.unsupportedApplePayPaymentMethods.localized()
        case .updateLockFailed: return SLTexts.Error.Domain.updateLockFailed.localized()
        case .invalidEmail: return SLTexts.Error.Domain.invalidEmail.localized()
        }
    }
}
