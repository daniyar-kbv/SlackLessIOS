//
//  File.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-19.
//

import Foundation
import UIKit
import SnapKit

final class ProgressReportView: ARView {
    private(set) lazy var dateSwitcherView = ARDateSwitcherView()
    
    private(set) lazy var dashboardView = ProgressDashboardView()
    
    private(set) lazy var firstChartView = SLContainerView()
    
    private(set) lazy var firstSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.firstSectionTitle.localized())
        view.addContainer(view: dashboardView)
        view.addContainer(view: firstChartView)
        return view
    }()
    
    private(set) lazy var secondChartView = SLContainerView()
    
    private(set) lazy var secondSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.secondSectonTitle.localized())
        view.addContainer(view: secondChartView)
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        set(title: SLTexts.Progress.title.localized())
        
        [dateSwitcherView, firstSectionView, secondSectionView].forEach(add(view:))
    }
}
