//
//  SLTexts.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation

enum SLTexts {
    enum Common {
        enum TermsAndPrivacy: String, Localizable {
            case text1 = "Common.TermsAndPrivacy.text1"
            case text2 = "Common.TermsAndPrivacy.text2"
            case text3 = "Common.TermsAndPrivacy.text3"
            case text4 = "Common.TermsAndPrivacy.text4"
        }
    }
    
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
            case updateLockFailed = "Error.Domain.updateLockFailed"
            case invalidEmail = "Error.Domain.invalidEmail"
        }
        
        enum Presentation: String, Localizable {
            case cantOpenTermsAndPrivacy = "Error.Presentation.cantOpenTermsAndPrivacy"
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
        case submit = "Button.submit"
    }

    enum Shield: String, Localizable {
        case title = "Shield.title"
        case primaryButtonTitle = "Shield.primaryButtonTitle"
        case secondaryButtonTitle = "Shield.secondaryButtonTitle"
        
        enum Subtitle: String, Localizable {
            case normal = "Shield.Subtitle.normal"
            case unlock = "Shield.Subtitle.unlock"
        }
    }

    enum WelcomeScreen: String, Localizable {
        case title = "WelcomeScreen.Title"
        case subtitle = "WelcomeScreen.Subtitle"
        case buttonText = "WelcomeScreen.ButtonText"
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
        
        enum Error: String, Localizable {
            case pushNotificationsUnauthorized = "Settings.Error.pushNotificationsUnauthorized"
        }
    }

    enum Unlock: String, Localizable {
        case buttonTitle = "Unlock.buttonTitle"
        case title = "Unlock.title"
        case subtitle = "Unlock.subtitle"
        case bottomButtonTitle = "Unlock.bottomButtonTitle"

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
    
    enum Feedback: String, Localizable {
        case title = "Feedback.title"
        case subtitle = "Feedback.subtitle"
        
        enum FirstTextView: String, Localizable {
            case placeholder = "Feedback.FirstTextView.placeholder"
            case bottomText = "Feedback.FirstTextView.bottomText"
        }
        
        enum SecondTextView: String, Localizable {
            case placeholder = "Feedback.SecondTextView.placeholder"
            case bottomText = "Feedback.SecondTextView.bottomText"
        }
        
        enum Error: String, Localizable {
            case invalidEmail = "Feedback.Error.invalidEmail"
            case bodyEmpty = "Feedback.Error.bodyEmpty"
        }
    }
}
