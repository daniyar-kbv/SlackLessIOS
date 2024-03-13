//
//  ResultsView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import UIKit
import SnapKit

final class ResultsView: SLView {
    private(set) lazy var topTitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 22, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var valueLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 64, weight: .bold)
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var bottomTitle: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 22, weight: .bold)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var logoImageView = UIImageView(image: SLImages.Common.logo.getImage())
    
    private(set) lazy var cloudsImageView = UIImageView(image: SLImages.Results.clouds.getImage())
    
    private(set) lazy var imagesView = UIView()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
        view.text = SLTexts.Common.Footnote.assessment.localized()
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var button = SLButton(style: .white, size: .large)
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [topTitleLabel, valueLabel, bottomTitle, imagesView, subtitleLabel, button])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 32
        view.setCustomSpacing(8, after: subtitleLabel)
        return view
    }()
    
    private var state: ResultsState?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutUI()
    }
    
    func set(state: ResultsState) {
        self.state = state
        updateState()
    }
    
    private func layoutUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.bottom.horizontalEdges.equalToSuperview()
        })
        
        imagesView.snp.makeConstraints({
            $0.height.equalTo(185)
        })
        
        button.snp.makeConstraints({
            $0.width.equalToSuperview()
        })
    }
    
    private func updateState() {
        updateTexts()
        updateImages()
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            self?.updateColors()
            self?.imagesView.layoutIfNeeded()
        }
    }
    
    private func updateTexts() {
        topTitleLabel.attributedText = state?.topTitle
        switch state {
        case let .spend(_, life): valueLabel.text = life
        case let .save(life): valueLabel.text = life
        default: break
        }
        bottomTitle.text = state?.bottomTitle
        button.setTitle(state?.buttonTitle, for: .normal)
    }
    
    private func updateColors() {
        backgroundColor = state?.backgroundColor
        valueLabel.textColor = state?.valueColor
        bottomTitle.textColor = state?.textColor
        subtitleLabel.textColor = state?.textColor
    }
    
    private func updateImages() {
        switch state {
        case .spend: break
        case .save:
            [logoImageView, cloudsImageView].forEach(imagesView.addSubview(_:))
            
            logoImageView.snp.makeConstraints({
                let logoSize = 64.0
                let logoOffset = -((Constants.screenSize.width/2)+(logoSize/2))
                $0.size.equalTo(logoSize)
                $0.centerX.equalToSuperview().offset(logoOffset)
                $0.top.equalToSuperview().offset(-(29+logoOffset))
            })
            
            cloudsImageView.snp.makeConstraints({
                let width = 532
                $0.width.equalTo(width)
                $0.verticalEdges.equalToSuperview()
                $0.centerX.equalToSuperview().offset(width)
            })
            
            imagesView.layoutIfNeeded()
            
            logoImageView.snp.updateConstraints({
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(29)
            })
            
            cloudsImageView.snp.updateConstraints({
                $0.centerX.equalToSuperview()
            })
        default: break
        }
    }
}
