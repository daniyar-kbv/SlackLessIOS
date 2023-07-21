//
//  ARSectionView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-05.
//

import Foundation
import UIKit

final class ARSectionView: UIStackView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .bold)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    init(titleText: String) {
        super.init(frame: .zero)
        
        layoutUI()
        setTitle(text: titleText)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [titleLabel].forEach(addArrangedSubview(_:))
        axis = .vertical
        spacing = 8
        distribution = .equalSpacing
        alignment = .fill
    }
}

extension ARSectionView {
    func setTitle(text: String) {
        titleLabel.text = text
    }
    
    func addContainer(view: UIView) {
        addArrangedSubview(view)
    }
}
