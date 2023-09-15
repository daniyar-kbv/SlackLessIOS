//
//  ProgressChangeView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-20.
//

import Foundation
import UIKit
import SnapKit

final class ProgressDashboardChangeView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label2.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .bold)
        view.adjustsFontSizeToFitWidth = true
        view.textAlignment = .center
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
        layer.cornerRadius = 16
        
        snp.makeConstraints({
            $0.size.equalTo(32)
        })
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(3)
        })
    }
    
    func set(change: TimeInterval?) {
        isHidden = change == nil
        guard let change = change else { return }
        let changeInt = Int(change*100)
        switch changeInt {
        case .min..<0:
            backgroundColor = SLColors.green.getColor()
            titleLabel.text = "\(changeInt)%"
        case 0:
            backgroundColor = SLColors.gray3.getColor()
            titleLabel.text = "\(changeInt)%"
        case 1...(.max):
            backgroundColor = SLColors.red.getColor()
            titleLabel.text = "+\(changeInt)%"
        default: break
        }
    }
}
