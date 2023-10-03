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
            case general = "Error.Domain.general"
            case request = "Error.Domain.request"
            case cantMakeApplePayPayment = "Error.Domain.cantMakeApplePayPayment"
            case unsupportedApplePayPaymentMethods = "Error.Domain.unsupportedApplePayPaymentMethods"
            case updateLimitsFailed = "Error.Domain.updateLimitsFailed"
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

        enum Title: String, Localizable {
            case normal = "Progress.Title.normal"
            case weeklyReport = "Progress.Title.weeklyReport"
        }

        enum FirstSectionTitle: String, Localizable {
            case normal = "Progress.FirstSectionTitle.normal"
            case weeklyReport = "Progress.FirstSectionTitle.weeklyReport"
        }

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
            
            enum UnlockPrice: String, Localizable {
                case placeholder = "Settigns.Settings.UnlockPrice.placeholder"
                
                enum Label: String, Localizable {
                    case normal = "Settings.Settings.UnlockPriceLabel.normal"
                    case setUp = "Settings.Settings.UnlockPriceLabel.setUp"
                }
            }
            
            enum SelectedAppsLabel: String, Localizable {
                case normal = "Settings.Settings.SelectedAppsLabel.normal"
                case setUp = "Settings.Settings.SelectedAppsLabel.setUp"
            }
            
            enum TimeLimitLabel: String, Localizable {
                case normal = "Settings.Settings.TimeLimitLabel.normal"
                case setUp = "Settings.Settings.TimeLimitLabel.setUp"
            }
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

    enum Unlock: String, Localizable {
        case buttonTitle = "Unlock.buttonTitle"
        case title = "Unlock.title"

        enum Payment: String, Localizable {
            case itemLabel = "Unlock.Payment.itemLabel"
        }

        enum Alert {
            enum Success: String, Localizable {
                case title = "Unlock.Alert.Success.title"
                case message = "Unlock.Alert.Success.message"
            }
        }
    }
}
