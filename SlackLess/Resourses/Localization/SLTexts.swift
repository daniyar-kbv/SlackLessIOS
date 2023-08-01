//
//  ABLocalization.swift
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
        
        enum FirstSection: String, Localizable {
            case title = "Customize.FirstSection.title"
            case selectedApps = "Customize.FirstSection.selectedApps"
            case timeLimit = "Customize.FirstSection.timeLimit"
            case unlockPrice = "Customize.FirstSection.unlockPrice"
        }
        
        enum SecondSection: String, Localizable {
            case title = "Customize.SecondSection.title"
            case pushNotifications = "Customize.SecondSection.pushNotifications"
            case email = "Customize.SecondSection.emails"
        }
    
        enum ThirdSection: String, Localizable {
            case title = "Customize.ThirdSection.title"
            case leaveFeedback = "Customize.ThirdSection.leaveFeedback"
        }
    }
}
