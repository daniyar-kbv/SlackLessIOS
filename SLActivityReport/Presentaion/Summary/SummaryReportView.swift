//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit
import SnapKit

final class SummaryReportView: ARView {
    private(set) lazy var dateSwitcherView = ARDateSwitcherView()
    
    private(set) lazy var firstSectionFirstContentView = SLContainerView()
    
    private(set) lazy var summarySelectedAppsDashboardView = SummarySelectedAppsDashboardView()
    
    private(set) lazy var secondSectionFirstContentView = SLContainerView()
    
    private(set) lazy var firstSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
        view.addContainer(view: firstSectionFirstContentView)
        view.addContainer(view: secondSectionFirstContentView)
        return view
    }()
    
    private(set) lazy var thirdSectionFirstContentView = SLContainerView()
    
    private(set) lazy var otherAppsDashboardView = SummaryOtherAppsDasboardView()
    
    private(set) lazy var fourthSectionFirstContentView = SLContainerView()
    
    private(set) lazy var secondSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Summary.secondSectonTitle.localized())
        view.addContainer(view: thirdSectionFirstContentView)
        view.addContainer(view: fourthSectionFirstContentView)
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
        set(title: SLTexts.Summary.title.localized())
        
        [dateSwitcherView, firstSectionView, secondSectionView].forEach(add(view:))
        
        firstSectionFirstContentView.addSubview(summarySelectedAppsDashboardView)
        summarySelectedAppsDashboardView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        thirdSectionFirstContentView.addSubview(otherAppsDashboardView)
        otherAppsDashboardView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
