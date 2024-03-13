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
        
        enum Footnote: String, Localizable {
            case assessment = "Common.Footnote.assessment"
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
    
    enum Survey {
        enum Title: String, Localizable {
            case question1 = "Survey.Title.question1"
            case question2 = "Survey.Title.question2"
        }
        
        enum Subtitle: String, Localizable {
            case question1 = "Survey.Subtitle.question1"
            case question2 = "Survey.Subtitle.question2"
        }
        
        enum Answers {
            enum Question1: String, Localizable {
                case answer1 = "Survey.Answers.Question1.answer1"
                case answer2 = "Survey.Answers.Question1.answer2"
                case answer3 = "Survey.Answers.Question1.answer3"
                case answer4 = "Survey.Answers.Question1.answer4"
                case answer5 = "Survey.Answers.Question1.answer5"
            }
            
            enum Question2: String, Localizable {
                case answer1 = "Survey.Answers.Question2.answer1"
                case answer2 = "Survey.Answers.Question2.answer2"
                case answer3 = "Survey.Answers.Question2.answer3"
                case answer4 = "Survey.Answers.Question2.answer4"
                case answer5 = "Survey.Answers.Question2.answer5"
                case answer6 = "Survey.Answers.Question2.answer6"
            }
        }
    }
    
    enum Calculation: String, Localizable {
        case subtitle = "Calculation.subtitle"
    }
    
    enum Results {
        enum TopTitle: String, Localizable {
            case spend = "Results.TopTitle.spend"
            case save = "Results.TopTitle.save"
        }
        
        enum BottomTitle: String, Localizable {
            case spend = "Results.BottomTitle.spend"
            case save = "Results.BottomTitle.save"
        }
        
        enum ButtonTitle: String, Localizable {
            case spend = "Results.ButtonTitle.spend"
            case save = "Results.ButtonTitle.save"
        }
    }
    
    enum RequestAuth: String, Localizable {
        case title = "RequestAuth.title"
        case subtitle = "RequestAuth.subtitle"
        case footnote = "RequestAuth.footnote"
    }
    
    enum Introduction {
        enum Title: String, Localizable {
            case summary = "Introduction.Title.summary"
            case lock = "Introduction.Title.lock"
            case progress = "Introduction.Title.progress"
        }
        
        enum Subtitle: String, Localizable {
            case summary = "Introduction.Subtitle.summary"
            case lock = "Introduction.Subtitle.lock"
            case progress = "Introduction.Subtitle.progress"
        }
        
        enum ButtonTitle: String, Localizable {
            case summary = "Introduction.ButtonTitle.summary"
            case lock = "Introduction.ButtonTitle.lock"
            case progress = "Introduction.ButtonTitle.progress"
        }
    }
    
    enum SetUp {
        enum Title: String, Localizable {
            case setUp = "SetUp.Title.setUp"
            case modify = "SetUp.Title.modify"
            case adjust = "SetUp.Title.adjust"
        }
        
        enum Subtitle: String, Localizable {
            case setUp = "SetUp.Subtitle.setUp"
            case modify = "SetUp.Subtitle.modify"
            case adjust = "SetUp.Subtitle.adjust"
        }
        
        enum ButtonTitle: String, Localizable {
            case setUp = "SetUp.ButtonTitle.setUp"
            case modify = "SetUp.ButtonTitle.modify"
            case adjust = "SetUp.ButtonTitle.adjust"
        }
    }
    
    enum Benefits: String, Localizable {
        case title = "Benefits.title"
        
        enum RowTitle: String, Localizable {
            case freeYourself = "Benefits.RowTitle.freeYourself"
            case reduceTime = "Benefits.RowTitle.reduceTime"
            case reviewProgress = "Benefits.RowTitle.reviewProgress"
        }
        
        enum RowSubtitle: String, Localizable {
            case freeYourself = "Benefits.RowSubtitle.freeYourself"
            case reduceTime = "Benefits.RowSubtitle.reduceTime"
            case reviewProgress = "Benefits.RowSubtitle.reviewProgress"
        }
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
            case buttonTitle = "Settings.Settings.buttonTitle"
            
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
        
        enum Alert {
            enum ModifySettings {
                enum Title: String, Localizable {
                    case first = "Settings.Alert.ModifySettings.Title.first"
                    case second = "Settings.Alert.ModifySettings.Title.second"
                }
                
                enum Message: String, Localizable {
                    case first = "Settings.Alert.ModifySettings.Message.first"
                    case second = "Settings.Alert.ModifySettings.Message.second"
                }
                
                enum Actions {
                    enum First: String, Localizable {
                        case first = "Settings.Alert.ModifySettings.Actions.First.first"
                        case second = "Settings.Alert.ModifySettings.Actions.First.second"
                    }
                    
                    enum Second: String, Localizable {
                        case first = "Settings.Alert.ModifySettings.Actions.Second.first"
                        case second = "Settings.Alert.ModifySettings.Actions.Second.second"
                    }
                }
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
        
        enum Alert: String, Localizable {
            case title = "Feedback.Alert.title"
            case message = "Feedback.Alert.message"
        }
    }
}
