//
//  SurveyType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-06.
//

import Foundation

enum SurveyQuestion {
    case question1
    case question2
    
    var title: String {
        switch self {
        case .question1: return SLTexts.Survey.Title.question1.localized()
        case .question2: return SLTexts.Survey.Title.question2.localized()
        }
    }
    
    var subtitle: String {
        switch self {
        case .question1: return SLTexts.Survey.Subtitle.question1.localized()
        case .question2: return SLTexts.Survey.Subtitle.question2.localized()
        }
    }
    
    var answers: [Answer] {
        switch self {
        case .question1: return [
            .init(title: SLTexts.Survey.Answers.Question1.answer1.localized(), value: 2),
            .init(title: SLTexts.Survey.Answers.Question1.answer2.localized(), value: 4),
            .init(title: SLTexts.Survey.Answers.Question1.answer3.localized(), value: 6),
            .init(title: SLTexts.Survey.Answers.Question1.answer4.localized(), value: 8),
            .init(title: SLTexts.Survey.Answers.Question1.answer5.localized(), value: 10),
        ]
        case .question2: return [
            .init(title: SLTexts.Survey.Answers.Question2.answer1.localized(), value: 18),
            .init(title: SLTexts.Survey.Answers.Question2.answer2.localized(), value: 25),
            .init(title: SLTexts.Survey.Answers.Question2.answer3.localized(), value: 35),
            .init(title: SLTexts.Survey.Answers.Question2.answer4.localized(), value: 45),
            .init(title: SLTexts.Survey.Answers.Question2.answer5.localized(), value: 55),
            .init(title: SLTexts.Survey.Answers.Question2.answer6.localized(), value: 65),
        ]
        }
    }
}

extension SurveyQuestion {
    struct Answer {
        let title: String
        let value: Int?
    }
}
