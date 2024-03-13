//
//  BenefitsRowType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-12.
//

import Foundation
import UIKit

enum BenefitType {
    case freeYourself
    case reduceTime(time: String)
    case reviewProgress(percentage: String)
    
    var image: UIImage? {
        switch self {
        case .freeYourself: return SLImages.Benefits.freeYourself.getImage()
        case .reduceTime: return SLImages.Benefits.reduceTime.getImage()
        case .reviewProgress: return SLImages.Benefits.reviewProgress.getImage()
        }
    }
    
    var title: String {
        switch self {
        case .freeYourself: return SLTexts.Benefits.RowTitle.freeYourself.localized()
        case .reduceTime: return SLTexts.Benefits.RowTitle.reduceTime.localized()
        case .reviewProgress: return SLTexts.Benefits.RowTitle.reviewProgress.localized()
        }
    }
    
    var subtitle: String {
        switch self {
        case .freeYourself: return SLTexts.Benefits.RowSubtitle.freeYourself.localized()
        case let .reduceTime(time): return SLTexts.Benefits.RowSubtitle.reduceTime.localized(time)
        case let .reviewProgress(percentage): return SLTexts.Benefits.RowSubtitle.reviewProgress.localized(percentage)
        }
    }
}
