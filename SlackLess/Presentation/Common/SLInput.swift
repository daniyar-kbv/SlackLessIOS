//
//  SLInput.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-30.
//

import Foundation
import SnapKit
import UIKit

final class SLInput: UIView {
    private let type: InputType
    private var value: Double?
    private let output: (Double?) -> Void

    private(set) lazy var timePicker: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private(set) lazy var textField: UITextField = {
        let view = UITextField()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        view.delegate = self
        view.keyboardType = .numberPad
        view.inputAccessoryView = nil
        return view
    }()

    init(type: InputType, value: Double?, output: @escaping (Double?) -> Void) {
        self.type = type
        self.value = value
        self.output = output

        super.init(frame: .zero)

        configure()
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        switch type {
        case .time:
            textField.inputView = timePicker
            if let value = value {
                timePicker.selectRow(value.get(component: .hours), inComponent: 0, animated: false)
                timePicker.selectRow(value.get(component: .minutes), inComponent: 3, animated: false)
            }
        case .price:
            break
        }
    }

    private func layoutUI() {
        backgroundColor = SLColors.gray5.getColor()
        layer.cornerRadius = 8

        addSubview(textField)
        textField.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(8)
        }

        switch type {
        case .time:
            textField.placeholder = "0:00"
            textField.text = value?.toString()
        case .price:
            textField.placeholder = "$1"
            textField.text = makePriceString(from: value)
        }
    }

    private func makePriceString(from value: Double?) -> String? {
        guard let value = value else { return nil }
        return "$\(Int(value))"
    }
}

extension SLInput: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.invalidateIntrinsicContentSize()
        guard let text = textField.text,
              let textRange = Range(range, in: text)
        else { return false }
        var updatedText = text.replacingCharacters(in: textRange,
                                                   with: string)
        switch type {
        case .time:
            break
        case .price:
            updatedText = updatedText.replacingOccurrences(of: "$", with: "")
            value = Double(updatedText) ?? 0
            updatedText = makePriceString(from: value) ?? makePriceString(from: 1)!
        }
        textField.text = updatedText
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch type {
        case .time:
            value = TimeInterval.makeFrom(hours: timePicker.selectedRow(inComponent: 0), minutes: timePicker.selectedRow(inComponent: 3))
            if value == 0 {
                value = nil
            }
            textField.text = value?.toString()
        case .price:
            if value == 0 {
                value = nil
            }
            textField.text = makePriceString(from: value)
        }
        output(value)
    }
}

extension SLInput: UIPickerViewDataSource {
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

extension SLInput: UIPickerViewDelegate {
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

extension SLInput {
    enum InputType {
        case time
        case price
    }
}
