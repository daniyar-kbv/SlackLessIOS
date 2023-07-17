//
//  SummaryReportView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-16.
//

import Foundation
import UIKit
import SnapKit

final class SummaryReportView: UIView {
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    private(set) lazy var contentView_ = UIView()
    
    private(set) lazy var dateSwitcherView = SLDateSwitcherView()
    
    private(set) lazy var pageView = UIView()
    
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
        clipsToBounds = false
        
        [scrollView].forEach(addSubview(_:))
        
        scrollView.snp.makeConstraints({
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        })
        
        scrollView.addSubview(contentView_)
        
        contentView_.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        })
        
        [dateSwitcherView, pageView].forEach(contentView_.addSubview(_:))
        
        dateSwitcherView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        pageView.snp.makeConstraints({
            $0.top.equalTo(dateSwitcherView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(2000)
        })
    }
}
