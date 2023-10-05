//
//  PresentationError.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-04.
//

import Foundation

enum PresentationError: ErrorPresentable {
    case cantOpenTermsAndPrivacy
    
    var presentationDescription: String {
        switch self {
        case .cantOpenTermsAndPrivacy: return SLTexts.Error.Presentation.cantOpenTermsAndPrivacy.localized()
        }
    }
}
