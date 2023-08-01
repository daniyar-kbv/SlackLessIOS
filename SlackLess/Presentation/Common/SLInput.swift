//
//  SLInput.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation
import UIKit
import SnapKit

final class SLInput: UIView {
    private let type: InputType
    
    private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.delegate = self
        view.keyboardType = .numberPad
        return view
    }()
    
    init(type: InputType) {
        self.type = type
        
        super.init(frame: .zero)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        backgroundColor = SLColors.gray5.getColor()
        layer.cornerRadius = 8
        
        addSubview(textField)
        textField.snp.makeConstraints({
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        })
        
        switch type {
        case .time: textField.text = "3:20"
        case .price: textField.text = "$1"
        }
    }
}

extension SLInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.invalidateIntrinsicContentSize()
        guard let text = textField.text,
              let textRange = Range(range, in: text)
        else { return false }
        let updatedText = text.replacingCharacters(in: textRange,
                                                   with: string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch type {
        case .time:
            return false
        case .price: return true
        }
    }
}

extension SLInput {
    enum InputType {
        case time
        case price
    }
}
