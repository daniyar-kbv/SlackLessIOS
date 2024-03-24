//
//  PresentationError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-04.
//

import Foundation

enum PresentationError: ErrorPresentable {
    case using(Error)
    case cantOpenTermsAndPrivacy
    case updateLockFailed
    
    var presentationDescription: String {
        switch self {
        case let .using(error): return error.localizedDescription
        case .cantOpenTermsAndPrivacy: return SLTexts.Error.Presentation.cantOpenTermsAndPrivacy.localized()
        case .updateLockFailed: return SLTexts.Error.Domain.updateLockFailed.localized()
        }
    }
}
