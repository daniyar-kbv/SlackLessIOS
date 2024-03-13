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
    
    enum Results: String, ImageGetable {
        case clouds = "Results.Clouds"
    }
    
    enum RequestAuth: String, ImageGetable {
        case alert = "RequestAuth.Alert"
    }
    
    enum Introduction: String, ImageGetable {
        case summary = "Introduction.Summary"
        case lock = "Introduction.Lock"
        case progress = "Introduction.Progress"
    }
    
    enum Benefits: String, ImageGetable {
        case freeYourself = "Benefits.freeYourself"
        case reduceTime = "Benefits.reduceTime"
        case reviewProgress = "Benefits.reviewProgress"
    }

    enum Settings: String, ImageGetable {
        case apps = "Settings.Apps"
        case time = "Settings.Time"
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

extension SLImages {
    enum EmojiType: String, CaseIterable {
        case alien
        case crying
        case emojiWithoutMouth
        case explodingFace
        case eye
        case eyes
        case ghost
        case highFive
        case poop
        case raisedHand
        case robot
        case selfie
        case skull
        case skullCross
        case snoring
        case surprised
        case surprised2
        case thinking
        case thinking2
        case upsideDownSmiling
    }
    
    static func getEmoji(_ type: EmojiType) -> UIImage? {
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "png", inDirectory: "Emoji")
        else { return Common.appIcon.getImage() }
        
        return UIImage(contentsOfFile: path)
    }
}
