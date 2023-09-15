//
//  ProgressDasboardView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit

final class ProgressDashboardView: UIStackView {
    private(set) lazy var firstContainer = ProgressDasboardContainerView(type: .first)
    private(set) lazy var secondContainer = ProgressDasboardContainerView(type: .second)
    private(set) lazy var thirdContainer = ProgressDasboardContainerView(type: .third)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [firstContainer, secondContainer, thirdContainer].forEach(addArrangedSubview(_:))
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
    }
}
