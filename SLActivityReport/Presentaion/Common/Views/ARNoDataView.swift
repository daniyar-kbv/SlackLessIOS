//
//  ARNoDataView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-12-04.
//

import Foundation
import UIKit
import SnapKit

final class ARNoDataView: UIView {
    private(set) lazy var label: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.gray3.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .regular)
        view.text = SLTexts.Common.NoData.title.localized()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
