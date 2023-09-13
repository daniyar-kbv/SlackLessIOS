//
//  SLReportsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftUI
import DeviceActivity

protocol SLReportsViewModel: AnyObject {
    var filters: [SLDeviceActivityReportFilter] { get }
}
