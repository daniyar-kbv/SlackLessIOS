//
//  CalculationController.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-07.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CalculationController: UIViewController {
    private(set) lazy var contentView = SLView()
    
    private(set) lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = SLImages.Common.logo.getImage()?.withRenderingMode(.alwaysTemplate)
        view.tintColor = SLColors.accent1.getColor()
        return view
    }()
    
    private(set) lazy var progressBar: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = SLColors.gray5.getColor()
        view.progressTintColor = SLColors.accent1.getColor()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.progress = 0.01
        return view
    }()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [logoView, progressBar])
        view.axis = .vertical
        view.spacing = 24
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .semibold)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.Calculation.subtitle.localized()
        return view
    }()
    
    let didFinish = PublishRelay<Void>()
    
    override func loadView() {
        super.loadView()
        
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressBar.progress = 1
        
        UIView.animate(withDuration: 10,
                       animations: { [weak self] in
            self?.progressBar.layoutIfNeeded()
        },
                       completion: { [weak self] in
            guard $0 else { return }
            self?.didFinish.accept(())
        })
    }
    
    private func layoutUI() {
        [stackView, subtitleLabel].forEach { contentView.addSubview($0) }
        
        logoView.snp.makeConstraints({
            $0.size.equalTo(64)
        })
        
        progressBar.snp.makeConstraints({
            $0.height.equalTo(8)
            $0.width.equalToSuperview()
        })
        
        stackView.snp.makeConstraints({
            $0.horizontalEdges.centerY.equalToSuperview()
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.bottom.equalToSuperview().offset(-16)
            $0.centerX.equalToSuperview()
        })
    }
}
