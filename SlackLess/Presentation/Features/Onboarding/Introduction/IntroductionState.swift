//
//  IntroductionState.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-10.
//

import Foundation
import UIKit

enum IntroductionState {
    case summary
    case lock
    case progress
    
    var image: UIImage? {
        switch self {
        case .summary: return SLImages.Introduction.summary.getImage()
        case .lock: return SLImages.Introduction.lock.getImage()
        case .progress: return SLImages.Introduction.progress.getImage()
        }
    }
    
    var title: String {
        switch self {
        case .summary: return SLTexts.Introduction.Title.summary.localized()
        case .lock: return SLTexts.Introduction.Title.lock.localized()
        case .progress: return SLTexts.Introduction.Title.progress.localized()
        }
    }
    
    var subtitle: String {
        switch self {
        case .summary: return SLTexts.Introduction.Subtitle.summary.localized()
        case .lock: return SLTexts.Introduction.Subtitle.lock.localized()
        case .progress: return SLTexts.Introduction.Subtitle.progress.localized()
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .summary: return SLTexts.Introduction.ButtonTitle.summary.localized()
        case .lock: return SLTexts.Introduction.ButtonTitle.lock.localized()
        case .progress: return SLTexts.Introduction.ButtonTitle.progress.localized()
        }
    }
}
