//
//  ProgressPastWeeksView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import UIKit
import SnapKit

final class ProgressPastWeeksView: UIView {
    private(set) lazy var chartView = SLContainerView()
    
    private(set) lazy var sectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.secondSectonTitle.localized())
        view.addContainer(view: chartView)
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
        
        addSubview(sectionView)
        sectionView.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
    }
}
