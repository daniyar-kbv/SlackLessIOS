//
//  AppCollectionDelegate.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-24.
//

import Foundation
import SwiftUI
import ManagedSettings

final class SummaryAppCollectionIconMaker {
    private var hostingControllers = [UIHostingController<ARAppIconView>]()
    
    weak var controller: UIViewController?
    
    func addAppIcon(to view: UIView?, with appToken: ApplicationToken?) {
        guard let token = appToken else { return }
        let appIconView = ARAppIconView(applicationToken: token)
        let hostingController = UIHostingController(rootView: appIconView)
        controller?.add(controller: hostingController, to: view)
        hostingControllers.append(hostingController)
    }
    
    func removeAppIcon(for appToken: ApplicationToken?) {
        guard let index = hostingControllers.firstIndex(where: { $0.rootView.applicationToken == appToken })
        else { return }
        let hostingController = hostingControllers[index]
        hostingControllers.remove(at: index)
        controller?.remove(controller: hostingController)
    }
}
