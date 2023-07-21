//
//  SLTabBarType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import UIKit

enum SLTabBarType {
    case summary
    case progress

    var tabBarItem: UITabBarItem {
        return .init(title: title, image: selectedImage, selectedImage: unselectedImage)
    }

    private var title: String {
        switch self {
        case .summary: return SLTexts.TabBar.summary.localized()
        case .progress: return SLTexts.TabBar.progress.localized()
        }
    }

    private var selectedImage: UIImage? {
        switch self {
        case .summary: return SLImages.TabBar.Summary.selected.getImage()
        case .progress: return SLImages.TabBar.Progress.selected.getImage()
        }
    }
    
    private var unselectedImage: UIImage? {
        switch self {
        case .summary: return SLImages.TabBar.Summary.unselected.getImage()
        case .progress: return SLImages.TabBar.Progress.unselected.getImage()
        }
    }
}
