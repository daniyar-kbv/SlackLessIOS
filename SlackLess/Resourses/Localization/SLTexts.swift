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
        
        enum NoData: String, Localizable {
            case title = "Common.NoData.title"
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
        
        enum Subtitle {
            enum Remind: String, CaseIterable, Localizable {
                case defaultText = "Shield.Subtitle.Remind.defaultText"
                case text1 = "Shield.Subtitle.Remind.text1"
                case text2 = "Shield.Subtitle.Remind.text2"
                case text3 = "Shield.Subtitle.Remind.text3"
                case text4 = "Shield.Subtitle.Remind.text4"
                case text5 = "Shield.Subtitle.Remind.text5"
                case text6 = "Shield.Subtitle.Remind.text6"
                case text7 = "Shield.Subtitle.Remind.text7"
                case text8 = "Shield.Subtitle.Remind.text8"
                case text9 = "Shield.Subtitle.Remind.text9"
                case text10 = "Shield.Subtitle.Remind.text10"
                case text11 = "Shield.Subtitle.Remind.text11"
                case text12 = "Shield.Subtitle.Remind.text12"
                case text13 = "Shield.Subtitle.Remind.text13"
                case text14 = "Shield.Subtitle.Remind.text14"
                case text15 = "Shield.Subtitle.Remind.text15"
                case text16 = "Shield.Subtitle.Remind.text16"
                case text17 = "Shield.Subtitle.Remind.text17"
                case text18 = "Shield.Subtitle.Remind.text18"
                case text19 = "Shield.Subtitle.Remind.text19"
                case text20 = "Shield.Subtitle.Remind.text20"
            }
            
            enum Lock: String, CaseIterable, Localizable {
                case defaultText = "Shield.Subtitle.Lock.defaultText"
                case text1 = "Shield.Subtitle.Lock.text1"
                case text2 = "Shield.Subtitle.Lock.text2"
                case text3 = "Shield.Subtitle.Lock.text3"
                case text4 = "Shield.Subtitle.Lock.text4"
                case text5 = "Shield.Subtitle.Lock.text5"
                case text6 = "Shield.Subtitle.Lock.text6"
                case text7 = "Shield.Subtitle.Lock.text7"
                case text8 = "Shield.Subtitle.Lock.text8"
                case text9 = "Shield.Subtitle.Lock.text9"
                case text10 = "Shield.Subtitle.Lock.text10"
                case text11 = "Shield.Subtitle.Lock.text11"
                case text12 = "Shield.Subtitle.Lock.text12"
                case text13 = "Shield.Subtitle.Lock.text13"
                case text14 = "Shield.Subtitle.Lock.text14"
                case text15 = "Shield.Subtitle.Lock.text15"
                case text16 = "Shield.Subtitle.Lock.text16"
                case text17 = "Shield.Subtitle.Lock.text17"
                case text18 = "Shield.Subtitle.Lock.text18"
                case text19 = "Shield.Subtitle.Lock.text19"
                case text20 = "Shield.Subtitle.Lock.text20"
            }
        }
        
        enum PrimaryButtonTitle: String, Localizable {
            case remind = "Shield.PrimaryButtonTitle.remind"
            case lock = "Shield.PrimaryButtonTitle.lock"
        }
        
        enum SecondaryButtonTitle: String, Localizable {
            case remind = "Shield.SecondaryButtonTitle.remind"
            case lock = "Shield.SecondaryButtonTitle.lock"
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
        
        enum Alert: String, Localizable {
            case title = "Feedback.Alert.title"
            case message = "Feedback.Alert.message"
        }
    }
}
