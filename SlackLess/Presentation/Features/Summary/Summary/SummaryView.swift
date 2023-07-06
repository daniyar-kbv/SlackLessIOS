//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import UIKit

final class SummaryView: SLView {
    private(set) lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delaysContentTouches = false
        return view
    }()
    
    private(set) lazy var contentView_: SLContentView = {
        let view = SLContentView()
        return view
    }()
    
    private(set) lazy var dateSwitcherView: SLDateSwitcherView = {
        let view = SLDateSwitcherView()
        return view
    }()
    
    private(set) lazy var firstSectionFirstContentView: SLContainerView = {
        let view = SLContainerView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var firstSectionView: SLSectionView = {
        let view = SLSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
        view.addContainer(view: firstSectionFirstContentView)
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
        
        [dateSwitcherView, firstSectionView].forEach(contentView_.addArrangedSubview(_:))
        
        firstSectionFirstContentView.snp.makeConstraints({
//            Refactor
            $0.height.equalTo((Constants.screenSize.width-64)/2+16)
        })
    }
}
