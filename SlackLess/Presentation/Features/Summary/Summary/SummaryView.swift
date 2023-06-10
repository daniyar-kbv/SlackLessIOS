//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit

final class SummaryView: UIView {
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        return view
    }()
    
    private(set) lazy var contentView: SLContentView = {
        let view = SLContentView()
        return view
    }()
    
    private(set) lazy var dateSwitcherView: SLDateSwitcherView = {
        let view = SLDateSwitcherView()
        return view
    }()
    
    private(set) lazy var dashboardView: SummaryDashboardView = {
        let view = SummaryDashboardView()
        return view
    }()
    
    private(set) lazy var firstSectionView: SLSectionView = {
        let view = SLSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
        view.addContainer(view: dashboardView)
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
        backgroundColor = SLColors.background1.getColor()
        
        [scrollView].forEach(addSubview(_:))
        
        scrollView.snp.makeConstraints({
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        })
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.width.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        })
        
        [dateSwitcherView, firstSectionView].forEach(contentView.addArrangedSubview(_:))
    }
}
