//
//  FeedbackView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import SnapKit
import UIKit

final class FeedbackView: SLBaseView {
    private(set) lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.text = SLTexts.Feedback.subtitle.localized()
        view.numberOfLines = 0
        return view
    }()
    
    private(set) lazy var emailTextView: SLTextViewContainer = {
        let view = SLTextViewContainer()
        view.textView.placeholder = SLTexts.Feedback.FirstTextView.placeholder.localized()
        view.bottomText = SLTexts.Feedback.FirstTextView.bottomText.localized()
        view.textView.keyboardType = .emailAddress
        view.textView.autocapitalizationType = .none
        return view
    }()
    
    private(set) lazy var bodyTextView: SLTextViewContainer = {
        let view = SLTextViewContainer()
        view.textView.placeholder = SLTexts.Feedback.SecondTextView.placeholder.localized()
        view.bottomText = SLTexts.Feedback.SecondTextView.bottomText.localized()
        return view
    }()
    
    private(set) lazy var textStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [emailTextView, bodyTextView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        return view
    }()

    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.setTitle(SLTexts.Button.submit.localized(), for: .normal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    private func layoutUI() {
        [button, subtitleLabel, emailTextView, bodyTextView].forEach { addSubview($0) }

        button.snp.makeConstraints({
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        subtitleLabel.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        })
        
        emailTextView.snp.makeConstraints({
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(0).priority(.low)
        })
        
        bodyTextView.snp.makeConstraints({
            $0.top.equalTo(emailTextView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(button.snp.top).offset(-32)
        })
    }
}

extension FeedbackView {
    enum FieldType {
        case email
        case body
    }
}
