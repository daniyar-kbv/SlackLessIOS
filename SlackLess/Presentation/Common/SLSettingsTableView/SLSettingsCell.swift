//
//  SLSettingsTableViewCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-29.
//

import Foundation
import UIKit
import SnapKit

final class SLSettingsCell: UITableViewCell {
    private var type: CellType?
    
    override var isHighlighted: Bool {
        didSet {
            guard let type = type,
                  type.inputType == .action
            else { return }
        }
    }
    
    private(set) lazy var iconView = UIImageView()
    
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        return view
    }()
    
    private(set) lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray3.getColor()
        return view
    }()
    
    private(set) lazy var rightItemView = UIView()
    
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconView, titleLabel, rightItemView])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUI() {
        [stackView, bottomLineView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints({
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        })
        
        bottomLineView.snp.makeConstraints({
            $0.bottom.right.equalToSuperview()
            $0.left.equalTo(titleLabel)
            $0.height.equalTo(0.5)
        })
        
        iconView.snp.makeConstraints({
            $0.size.equalTo(28)
        })
    }
    
    func set(type: CellType) {
        iconView.image = type.image
        titleLabel.text = type.title
        
        rightItemView.subviews.forEach({ $0.removeFromSuperview() })
        var inputView: UIView?
        
        switch type.inputType {
        case .action:
            inputView = UIImageView(image: SLImages.Common.Arrows.Chevron.right.getImage())
        case .timeInput:
            inputView = SLInput(type: .time)
        case .priceInput:
            inputView = SLInput(type: .price)
        case .toggle:
            inputView = UISwitch()
        }
        
        guard let inputView = inputView else { return }
        rightItemView.addSubview(inputView)
        inputView.snp.makeConstraints({
            $0.edges.equalToSuperview()
            $0.size.equalTo(16)
        })
    }
}

extension SLSettingsCell {
    enum CellType: String {
        case selectedApps
        case timeLimit
        case unlockPrice
        case pushNotifications
        case emails
        case leaveFeedback
        
        var reuseIdentifier: String {
            return "SettingsTableViewCell.\(self.rawValue)"
        }
        
        var image: UIImage? {
            switch self {
            case .selectedApps: return SLImages.Settings.apps.getImage()
            case .timeLimit: return SLImages.Settings.time.getImage()
            case .unlockPrice: return SLImages.Settings.price.getImage()
            case .pushNotifications: return SLImages.Settings.notifications.getImage()
            case .emails: return SLImages.Settings.emails.getImage()
            case .leaveFeedback: return SLImages.Settings.feedback.getImage()
            }
        }
        
        var title: String? {
            switch self {
            case .selectedApps: return SLTexts.Customize.FirstSection.selectedApps.localized()
            case .timeLimit: return SLTexts.Customize.FirstSection.timeLimit.localized()
            case .unlockPrice: return SLTexts.Customize.FirstSection.unlockPrice.localized()
            case .pushNotifications: return SLTexts.Customize.SecondSection.pushNotifications.localized()
            case .emails: return SLTexts.Customize.SecondSection.email.localized()
            case .leaveFeedback: return SLTexts.Customize.ThirdSection.leaveFeedback.localized()
            }
        }
        
        var inputType: InputType {
            switch self {
            case .selectedApps, .leaveFeedback: return .action
            case .timeLimit: return .timeInput
            case .unlockPrice: return .priceInput
            case .pushNotifications, .emails: return .toggle
            }
        }
    }
    
    enum InputType {
        case action
        case timeInput
        case priceInput
        case toggle
    }
}
