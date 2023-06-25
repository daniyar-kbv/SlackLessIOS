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
    
    private(set) lazy var firstSectionView: SLSectionView = {
        let view = SLSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
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
            $0.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        })
        
        scrollView.addSubview(contentView_)
        
        contentView_.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        [dateSwitcherView, firstSectionView].forEach(contentView_.addArrangedSubview(_:))
    }
}
