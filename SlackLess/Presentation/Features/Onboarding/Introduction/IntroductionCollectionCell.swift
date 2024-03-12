//
//  IntroductionCollectionCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-10.
//

import Foundation
import UIKit
import SnapKit

final class IntroductionCollectionCell: UICollectionViewCell {
    private(set) lazy var screenImageView = UIImageView()
    
    private(set) lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.001)
        return view
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 22, weight: .bold)
        view.textColor = SLColors.accent1.getColor()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 17, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var backgroundBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.background1.getColor()
        return view
    }()
    
    private lazy var gradientLayer = gradientView.addGradient([(SLColors.background1.getColor() ?? .white).withAlphaComponent(0),
                                                               (SLColors.background1.getColor() ?? .white).withAlphaComponent(0),
                                                               SLColors.background1.getColor() ?? .white,
                                                               SLColors.background1.getColor() ?? .white],
                                                              locations: [0, 0.7, 0.99, 1],
                                                              startPoint: .init(x: 0.5, y: 0),
                                                              endPoint: .init(x: 0.5, y: 1))
    var state: IntroductionState? {
        didSet { updateState() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        state = nil
    }
    
    private func updateState() {
        screenImageView.image = state?.image
        titleLabel.text = state?.title
        subtitleLabel.text = state?.subtitle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        screenImageView.snp.updateConstraints({
            $0.height.equalTo(bounds.width*(932/473))
        })
        
        gradientLayer.frame = gradientView.frame
    }
    
    func layoutUI() {
        [screenImageView, backgroundBottomView, gradientView].forEach { addSubview($0) }
        
        screenImageView.snp.makeConstraints({
            $0.height.equalTo(0)
            $0.top.horizontalEdges.equalToSuperview()
        })
        
        backgroundBottomView.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        
        [titleLabel, subtitleLabel].forEach { backgroundBottomView.addSubview($0) }
        
        subtitleLabel.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        
        titleLabel.snp.makeConstraints({
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-8)
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().offset(16)
        })
        
        gradientView.snp.makeConstraints({
            $0.bottom.equalTo(backgroundBottomView.snp.top)
            $0.horizontalEdges.top.equalToSuperview()
        })
    }
}


