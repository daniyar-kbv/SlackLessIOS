//
//  SLProgressType.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-26.
//

import Foundation

enum SLProgressType {
    case normal
    case weeklyReport

    var title: String {
        switch self {
        case .normal: return SLTexts.Progress.Title.normal.localized()
        case .weeklyReport: return SLTexts.Progress.Title.weeklyReport.localized()
        }
    }

    var firstSectionTitle: String {
        switch self {
        case .normal: return SLTexts.Progress.FirstSectionTitle.normal.localized()
        case .weeklyReport: return SLTexts.Progress.FirstSectionTitle.weeklyReport.localized()
        }
    }

    var reportType: SLDeviceActivityReportType {
        switch self {
        case .normal: return .progress
        case .weeklyReport: return .weeklyReport
        }
    }

    var hideDateSwitcher: Bool {
        switch self {
        case .normal: return false
        case .weeklyReport: return true
        }
    }

    var hideButton: Bool {
        switch self {
        case .normal: return true
        case .weeklyReport: return false
        }
    }

    var bottomOffset: CGFloat {
        switch self {
        case .normal: return 16
        case .weeklyReport: return 76
        }
    }

    var addTopOffset: Bool {
        switch self {
        case .normal: return false
        case .weeklyReport: return true
        }
    }
}
