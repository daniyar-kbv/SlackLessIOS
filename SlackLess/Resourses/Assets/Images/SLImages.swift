//
//  SLImages.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit

enum SLImages: String, ImageGetable {
    case appIcon = "AppIcon"

    enum NavBar: String, ImageGetable {
        case back = "NavBar.back"
    }

    enum TabBar {
        enum Summary: String, ImageGetable {
            case selected = "TabBar.Summary.selected"
            case unselected = "TabBar.Summary.unselected"
        }
        
        enum Progress: String, ImageGetable {
            case selected = "TabBar.Progress.selected"
            case unselected = "TabBar.Progress.unselected"
        }
    }

    enum Common: String, ImageGetable {
        case logo = "Common.Logo"
        
        enum Arrows {
            enum Circle: String, ImageGetable {
                case right = "Common.Arrows.Cicle.right"
                case left = "Common.Arrows.Cicle.left"
            }
        }
    }

    enum WelcomeScreen: String, ImageGetable {
        case main = "WelcomeScreen.Main"
    }
}
