//
//  SLReportsViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import DeviceActivity
import Foundation
import RxCocoa
import RxSwift
import SwiftUI

protocol SLReportsViewModel: AnyObject {
    var filters: [SLDeviceActivityReportFilter] { get }
}
