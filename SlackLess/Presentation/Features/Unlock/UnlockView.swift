//
//  UnlockView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-27.
//

import Foundation
import PassKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class UnlockView: SLBaseView {
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = SLColors.label1.getColor()
        view.font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var settingsView = UIView()
    
    private(set) lazy var stretchableView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
        return view
    }()
    
    private(set) lazy var termsLabel: UILabel = {
        let view = UILabel()
//        FIXME: Change localize "Pay"
        view.attributedText = SLTexts.Common.TermsAndPrivacy.makeText(
            font: SLFonts.primary.getFont(ofSize: 13, weight: .regular),
            baseColor: SLColors.label1.getColor(),
            accentColor: SLColors.accent1.getColor(),
            split: false,
            clickElementName: "Pay")
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var applePayButtonContainer = UIView()
    
    private(set) lazy var bottomButton: SLButton = {
        let view = SLButton(style: .gray, size: .medium)
        view.setTitle(SLTexts.Unlock.bottomButtonTitle.localized(String(Int(Constants.Settings.shortUnlockTime.get(component: .minutes)))), for: .normal)
        return view
    }()
    
    private(set) var applePayButton: PKPaymentButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [subtitleLabel, settingsView, stretchableView, termsLabel, applePayButtonContainer, bottomButton].forEach({ addSubview($0) })
        
        subtitleLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        settingsView.snp.makeConstraints({
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
        })
        
        stretchableView.snp.makeConstraints({
            $0.top.equalTo(settingsView.snp.bottom).offset(32)
        })
        
        termsLabel.snp.makeConstraints({
            $0.top.equalTo(stretchableView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        applePayButtonContainer.snp.makeConstraints({
            $0.top.equalTo(termsLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        bottomButton.snp.makeConstraints({
            $0.top.equalTo(applePayButtonContainer.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        })
    }

    func setUpApplePayButton(for state: SLApplePayState) -> PKPaymentButton? {
        switch state {
        case .pay:
            applePayButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
        case .setUp:
            applePayButton = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
        case .failure:
            applePayButton = .none
        }

        guard let applePayButton = applePayButton else { return nil }
        
        applePayButton.cornerRadius = SLButton(style: .filled, size: .large).layer.cornerRadius

        applePayButtonContainer.addSubview(applePayButton)
        applePayButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(SLButton.Size.large.height)
        }

        return applePayButton
    }
}
