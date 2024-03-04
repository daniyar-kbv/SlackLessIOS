//
//  SLTimeInput.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2024-03-03.
//

import Foundation
import UIKit
import SnapKit

final class SLTimeInput: UIView {
    private var dateComponents: DateComponents?
    private let onChange: (DateComponents) -> Void

    private(set) lazy var timePicker: UIPickerView = {
        let view = UIPickerView(frame: .init(x: 0, y: 0, width: Constants.screenSize.width, height: 400))
        
        view.dataSource = self
        view.delegate = self
        
        if let dateComponents = dateComponents {
            view.selectRow(dateComponents.hour ?? 0, inComponent: 0, animated: false)
            view.selectRow(dateComponents.minute ?? 0, inComponent: 3, animated: false)
        }
        return view
    }()

    private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.delegate = self
        view.keyboardType = .numberPad
        view.inputView = timePicker
        view.placeholder = TimeInterval.makeFrom(DateComponents(hour: 0, minute: 0)).toString()
        view.text = TimeInterval.makeFrom(dateComponents).toString()
        return view
    }()

    init(dateComponents: DateComponents?, onChange: @escaping (DateComponents) -> Void) {
        self.dateComponents = dateComponents
        self.onChange = onChange

        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = SLColors.gray5.getColor()
        layer.cornerRadius = 8

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
    }
}

extension SLTimeInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.invalidateIntrinsicContentSize()
        guard let text = textField.text,
              let textRange = Range(range, in: text)
        else { return false }
        let updatedText: String? = text.replacingCharacters(in: textRange,
                                                   with: string)
        
        textField.text = updatedText
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateCursor(for: textField)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateCursor(for: textField)
    }
    
    private func updateCursor(for textFiel: UITextField) {
        guard let newPosition = textField.position(from: textField.endOfDocument,
                                                   offset: -(textField.text?.components(separatedBy: "/").last?.count ?? 0) - 1)
        else { return }
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let dateComponents = DateComponents(hour: timePicker.selectedRow(inComponent: 0), minute: timePicker.selectedRow(inComponent: 3))
        self.dateComponents = dateComponents
        
        textField.text = TimeInterval.makeFrom(dateComponents).toString()
        
        onChange(dateComponents)
    }
}

extension SLTimeInput: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        5
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 24
        case 1: return 1
        case 2: return 1
        case 3: return 60
        case 4: return 1
        default: return 0
        }
    }
}

extension SLTimeInput: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0, 3: return String(row)
        case 1: return "h"
        case 4: return "m"
        default: return nil
        }
    }

    func pickerView(_: UIPickerView, widthForComponent _: Int) -> CGFloat {
        return 50
    }
}
