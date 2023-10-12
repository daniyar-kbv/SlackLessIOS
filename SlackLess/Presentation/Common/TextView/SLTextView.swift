//
//  SLTextField.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-10-10.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SLTextView: UITextView {
    let didStartEditing = PublishRelay<String>()
    let didEndEditing = PublishRelay<String>()
    
    private(set) var state: State = .normal {
        didSet {
            placeholderLabel.textColor = state.placeholderColor
            textColor = state.textColor
        }
    }
    
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    private(set) lazy var placeholderLabel: UILabel = {
        let view = UILabel()
        view.text = placeholder
        view.textColor = state.placeholderColor
        view.numberOfLines = 0
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        layoutUI()
    }

    private func layoutUI() {
        delegate = self
        isScrollEnabled = false
        contentInset = .init(top: 8, left: 16, bottom: 8, right: 16)
        backgroundColor = SLColors.backgroundElevated.getColor()
        layer.cornerRadius = 8
        font = SLFonts.primary.getFont(ofSize: 16, weight: .regular)
        textColor = state.textColor
        isScrollEnabled = true
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(4)
            $0.verticalEdges.equalToSuperview().inset(8)
        })
        
        snp.makeConstraints({
            $0.height.greaterThanOrEqualTo("Dummy".height(withConstrainedWidth: 100, font: font ?? .systemFont(ofSize: 16))+16)
        })
    }
}

extension SLTextView {
    func set(state: State) {
        self.state = state
    }
}

extension SLTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        didStartEditing.accept(textView.text)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        didEndEditing.accept(textView.text)
    }
}

extension SLTextView {
    enum State {
        case normal
        case error
        
        var placeholderColor: UIColor? {
            switch self {
            case .normal: return SLColors.gray2.getColor()
            case .error: return SLColors.red.getColor()
            }
        }
        
        var textColor: UIColor? {
            switch self {
            case .normal: return SLColors.label1.getColor()
            case .error: return SLColors.red.getColor()
            }
        }
    }
}
