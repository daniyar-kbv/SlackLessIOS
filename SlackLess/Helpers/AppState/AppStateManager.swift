//
//  AppStateManager.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation

protocol AppStateManagerInput {
    
}

protocol AppStateManagerOutput {
    func getAppMode() -> AppMode
}

protocol AppStateManager: AnyObject {
    var input: AppStateManagerInput { get }
    var output: AppStateManagerOutput { get }
}

final class AppStateManagerImpl: AppStateManager, AppStateManagerInput, AppStateManagerOutput {
    var input: AppStateManagerInput { self }
    var output: AppStateManagerOutput { self }
    
    private let appMode: AppMode = .debug
    
    //    Output
    func getAppMode() -> AppMode {
        appMode
    }
    
    //    Input
    
}
