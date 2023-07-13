//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit
import SnapKit

final class SummaryView: SLView {
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    private(set) lazy var contentView_ = SLContentView()
    
    private(set) lazy var dateSwitcherView = SLDateSwitcherView()
    
    private(set) lazy var firstSectionFirstContentView = SLContainerView()
    
    private(set) lazy var summarySelectedAppsDashboardView = SummarySelectedAppsDashboardView()
    
    private(set) lazy var secondSectionFirstContentView = SLContainerView()
    
    private(set) lazy var firstSectionView: SLSectionView = {
        let view = SLSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
        view.addContainer(view: firstSectionFirstContentView)
        view.addContainer(view: secondSectionFirstContentView)
        return view
    }()
    
    private(set) lazy var thirdSectionFirstContentView = SLContainerView()
    
    private(set) lazy var otherAppsDashboardView = SummaryOtherAppsDasboardView()
    
    private(set) lazy var fourthSectionFirstContentView = SLContainerView()
    
    private(set) lazy var secondSectionView: SLSectionView = {
        let view = SLSectionView(titleText: SLTexts.Summary.secondSectonTitle.localized())
        view.addContainer(view: thirdSectionFirstContentView)
        view.addContainer(view: fourthSectionFirstContentView)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = SLColors.background1.getColor()
        
        [scrollView].forEach(addSubview(_:))
        
        scrollView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        scrollView.addSubview(contentView_)
        
        contentView_.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        [dateSwitcherView, firstSectionView, secondSectionView].forEach(contentView_.addArrangedSubview(_:))
        
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
