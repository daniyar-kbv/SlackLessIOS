//
//  ProgressView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import UIKit
import SnapKit

final class ProgressView: ARView {
    private(set) lazy var dashboardView = ProgressDashboardView()
    
    private(set) lazy var firstContentView = SLContainerView()
    
    private(set) lazy var firstSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.firstSectionTitle.localized())
        view.addContainer(view: dashboardView)
        view.addContainer(view: firstContentView)
        return view
    }()
    
    private(set) lazy var secondContentView = SLContainerView()
    
    private(set) lazy var secondSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.secondSectonTitle.localized())
        view.addContainer(view: secondContentView)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [firstSectionView, secondSectionView].forEach(add(view:))
    }
}
