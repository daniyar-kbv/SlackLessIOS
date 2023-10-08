//
//  SLTabBarViewModel.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-05-29.
//

import Foundation
import RxCocoa
import RxSwift

protocol SLTabBarViewModelInput: AnyObject {
}

protocol SLTabBarViewModelOutput: AnyObject {
}

protocol SLTabBarViewModel: AnyObject {
    var input: SLTabBarViewModelInput { get }
    var output: SLTabBarViewModelOutput { get }
}

final class SLTabBarViewModelImpl: SLTabBarViewModel, SLTabBarViewModelInput, SLTabBarViewModelOutput {
    var input: SLTabBarViewModelInput { self }
    var output: SLTabBarViewModelOutput { self }
    //    Output
    
    //    Input
}
