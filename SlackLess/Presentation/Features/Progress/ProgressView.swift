//
//  ProgressView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import UIKit
import SnapKit

final class ProgressView: SLBaseView {
    private(set) lazy var dateSwitcherView = SLDateSwitcherView()
    
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        view.showsVerticalScrollIndicator = false
        view.contentInset = .init(top: view.safeAreaLayoutGuide.layoutFrame.size.height, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    private(set) lazy var contentView = SLContentView()
    
    private(set) lazy var weekReportView = UIView()
    private(set) lazy var pastWeeksReportView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [dateSwitcherView, scrollView].forEach(addSubview(_:))
        
        dateSwitcherView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(28)
        })
        
        scrollView.snp.makeConstraints({
            $0.top.equalTo(dateSwitcherView.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        })
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.bottom.width.equalToSuperview()
        })
        
        [weekReportView, pastWeeksReportView].forEach(contentView.addSubview(_:))
        
        weekReportView.snp.makeConstraints({
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(421)
        })
        
        pastWeeksReportView.snp.makeConstraints({
            $0.top.equalTo(weekReportView.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(262)
        })
    }
}
