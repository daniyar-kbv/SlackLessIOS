//
//  SLImages.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import UIKit

//  TODO: Refactor image names to match Enum names and remove raw values
//  TODO: Refactor SF Symbols to use UIImage(systemName: )

enum SLImages {
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

        enum Customize: String, ImageGetable {
            case selected = "TabBar.Customize.selected"
            case unselected = "TabBar.Customize.unselected"
        }
    }

    enum Common: String, ImageGetable {
        case appIcon = "Comon.AppIcon"
        case logo = "Common.Logo"
        case appIconPlaceholder = "Common.AppIcon.Placeholder"

        enum Arrows {
            enum Chevron: String, ImageGetable {
                case right = "Common.Arrows.Chevron.Right"
            }

            enum Circle: String, ImageGetable {
                case right = "Common.Arrows.Cicle.right"
                case left = "Common.Arrows.Cicle.left"
            }
        }
    }

    enum WelcomeScreen: String, ImageGetable {
        case main = "WelcomeScreen.Main"
    }

    enum Settings: String, ImageGetable {
        case apps = "Settings.Apps"
        case time = "Settings.Time"
        case price = "Settings.Price"
        case notifications = "Settings.Notifications"
        case emails = "Settings.Emails"
        case feedback = "Settings.Feedback"
    }
}

extension SLImages {
    static func getIcon(for bundleID: String) -> UIImage? {
        if Bundle.main.bundleIdentifier?.contains(bundleID) ?? false {
            return Common.appIcon.getImage()
        }
        if let path = Bundle.main.path(forResource: bundleID, ofType: "png", inDirectory: "AppIcons") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }
}
