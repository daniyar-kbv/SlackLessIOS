//
//  SLTexts.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum SLTexts {
    enum Error {
        enum Data: String, Localizable {
            case badMapping = "Error.Data.badmapping"
            case noData = "Error.Data.noData"
        }

        enum Domain: String, Localizable {
            case request = "Error.Domain.request"
            case categoriesNotAllowed = "Error.Domain.categoriesNotAllowed"
        }
    }

    enum Keyboard {
        enum Toolbar: String, Localizable {
            case done = "Keyboard.Toolbar.done"
        }
    }

    enum Alert {
        enum Error: String, Localizable {
            case title = "Alert.Error.title"
        }

        enum Action: String, Localizable {
            case defaultTitle = "Alert.Action.defauiltTitle"
            case cancel = "Alert.Action.cancel"
            case toSettings = "Alert.Action.toSettings"
            case yes = "Alert.Action.yes"
            case no = "Alert.Action.no"
        }
    }

    enum TabBar: String, Localizable {
        case summary = "TabBar.summaryTitle"
        case progress = "TabBar.progressTitle"
        case customize = "TabBar.customizeTitle"
    }

    enum Button: String, Localizable {
        case continue_ = "Button.continue"
    }

    enum Shield: String, Localizable {
        case title = "Shield.title"
        case subtitle = "Shield.subtitle"
        case primaryButtonTitle = "Shield.primaryButtonTitle"
        case secondaryButtonTitle = "Shield.secondaryButtonTitle"
    }

    enum WelcomeScreen: String, Localizable {
        case title = "WelcomeScreen.Title"
        case subtitle = "WelcomeScreen.Subtitle"
        case buttonText = "WelcomeScreen.ButtonText"
        case termsAndPrivacy1 = "WelcomeScreen.TermsAndPrivacy1"
        case termsAndPrivacy2 = "WelcomeScreen.TermsAndPrivacy2"
        case termsAndPrivacy3 = "WelcomeScreen.TermsAndPrivacy3"
        case termsAndPrivacy4 = "WelcomeScreen.TermsAndPrivacy4"
    }

    enum SetUp: String, Localizable {
        case title = "SetUp.title"
        case subtitle = "SetUp.subtitle"
        case bottomText = "SetUp.bottomText"
    }

    enum Legend: String, Localizable {
        case firstTitle = "Legend.firstTitle"
        case secondTitle = "Legend.secondTitle"
    }

    enum Summary: String, Localizable {
        case title = "Summary.title"
        case firstSectionTitle = "Summary.firstSectionTitle"
        case secondSectonTitle = "Summary.secondSectonTitle"

        enum FirstContainer: String, Localizable {
            case title = "Summary.FirstContainer.title"
            case subtitle = "Summary.FirstContainer.subitle"
        }

        enum ThirdContainer: String, Localizable {
            case title = "Summary.ThirdContainer.title"
        }
    }

    enum Progress: String, Localizable {
        case title = "Progress.title"
        case firstSectionTitle = "Progress.firstSectionTitle"
        case secondSectonTitle = "Progress.secondSectonTitle"

        enum Dashboard: String, Localizable {
            case firstTitle = "Progress.Dashboard.firstTitle"
            case secondTitle = "Progress.Dashboard.secondTitle"
            case thirdTitle = "Progress.Dashboard.thirdTitle"
        }
    }

    enum Customize: String, Localizable {
        case title = "Customize.title"
    }

    enum Settings {
        enum Settings: String, Localizable {
            case title = "Settings.Settings.title"
            case selectedApps = "Settings.Settings.selectedApps"
            case timeLimit = "Settings.Settings.timeLimit"
            case unlockPrice = "Settings.Settings.unlockPrice"
        }

        enum Notifications: String, Localizable {
            case title = "Settings.Notifications.title"
            case pushNotifications = "Settings.Notifications.pushNotifications"
            case email = "Settings.Notifications.emails"
        }

        enum Feedback: String, Localizable {
            case title = "Settings.Feedback.title"
            case leaveFeedback = "Settings.Feedback.leaveFeedback"
        }
    }
}
