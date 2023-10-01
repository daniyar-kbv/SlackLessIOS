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
    private(set) var applePayButton: PKPaymentButton?
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {}

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

        addSubview(applePayButton)
        applePayButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.height.equalTo(SLButton.Size.large.height)
        }

        return applePayButton
    }
}
