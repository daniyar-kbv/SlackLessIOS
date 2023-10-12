//
//  FeedbackView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import SnapKit
import UIKit

final class FeedbackView: SLView {
    private(set) lazy var largeTitleView: SLLargeTitleView = {
        let view = SLLargeTitleView()
        view.title = SLTexts.Feedback.title.localized()
        view.subtitle = SLTexts.Feedback.subtitle.localized()
        return view
    }()
    
    private(set) lazy var emailTextView: SLTextViewContainer = {
        let view = SLTextViewContainer()
        view.placeholder = SLTexts.Feedback.FirstTextView.placeholder.localized()
        view.bottomText = SLTexts.Feedback.SecondTextView.bottomText.localized()
        return view
    }()
    
    private(set) lazy var bodyTextView: SLTextViewContainer = {
        let view = SLTextViewContainer()
        view.placeholder = SLTexts.Feedback.FirstTextView.placeholder.localized()
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
        [button, largeTitleView].forEach { addSubview($0) }

        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        largeTitleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }
        
        largeTitleView.addSubview(textStackView)
    }
}

extension FeedbackView {
    enum FieldType {
        case email
        case body
    }
}
