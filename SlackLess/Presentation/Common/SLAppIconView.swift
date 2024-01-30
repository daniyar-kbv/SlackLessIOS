//
//  SLAppIconView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-12-08.
//

import Foundation
import UIKit
import SnapKit

final class SLAppIconView: UIView {
    private(set) lazy var imageView = UIImageView()
    
    private(set) lazy var letterLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.accent1.getColor()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        letterLabel.font = SLFonts.primary.getFont(ofSize: bounds.height/2, weight: .bold)
        layer.cornerRadius = bounds.height/5
    }
    
    private func layoutUI() {
        clipsToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = SLColors.gray4.getColor()?.cgColor
    }
    
    func update(with bundleId: String, appName: String) {
        subviews.forEach({ $0.removeFromSuperview() })
        
        if let image = SLImages.getIcon(for: bundleId) {
            imageView.image = image
            addSubview(imageView)
            imageView.snp.makeConstraints({
                $0.edges.equalToSuperview()
            })
        } else {
            letterLabel.text = String(appName.prefix(1))
            addSubview(letterLabel)
            letterLabel.snp.makeConstraints({
                $0.center.equalToSuperview()
            })
        }
    }
}
