//
//  SLSettingsCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-29.
//

import Foundation
import SnapKit
import UIKit

final class SLSettingsCell: UITableViewCell {
    private var type: CellType?
    private var output: ((OutputType) -> Void)?

    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        return view
    }()

    private(set) lazy var iconView = UIImageView()

    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 15, weight: .regular)
        view.textColor = SLColors.label1.getColor()
        return view
    }()

    private(set) lazy var leftItemsStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconView, titleLabel])
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        return view
    }()

    private(set) lazy var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.gray3.getColor()
        return view
    }()

    private(set) lazy var rightItemView = UIView()

    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leftItemsStack, rightItemView])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        type = nil
        output = nil
        rightItemView.subviews.forEach { $0.removeFromSuperview() }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        guard type?.inputType == .action else { return }

        output?(.trigger)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        guard type?.inputType == .action else { return }

        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.containerView.backgroundColor = highlighted ? SLColors.gray5.getColor() : SLColors.backgroundElevated.getColor()
        }
    }

    private func layoutUI() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.layer.cornerRadius = 8

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        [stackView, bottomLineView].forEach(containerView.addSubview(_:))

        stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.verticalEdges.equalToSuperview()
        }

        bottomLineView.snp.makeConstraints {
            $0.bottom.right.equalToSuperview()
            $0.left.equalTo(titleLabel)
            $0.height.equalTo(0.5)
        }

        iconView.snp.makeConstraints {
            $0.size.equalTo(28)
        }
    }

    func set(type: CellType, position: Position, output: @escaping (OutputType) -> Void) {
        self.type = type
        self.output = output

        iconView.image = type.image
        titleLabel.text = type.title

        var inputView: UIView?

        switch type.inputType {
        case .action:
            inputView = UIImageView(image: SLImages.Common.Arrows.Chevron.right.getImage())
        case let .timeInput(limit):
            inputView = SLInput(type: .time, value: limit) { _ in
            }
        case let .priceInput(price):
            inputView = SLInput(type: .price, value: Double(price)) { _ in
            }
        case .toggle:
            inputView = UISwitch()
        }

        if let inputView = inputView {
            rightItemView.addSubview(inputView)
            inputView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                if type.inputType == .action {
                    $0.size.equalTo(16)
                }
            }
        }

        bottomLineView.isHidden = [.bottom, .single].contains(position)

        switch position {
        case .single:
            containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        case .top:
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .middle:
            containerView.layer.maskedCorners = []
        case .bottom:
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}

extension SLSettingsCell {
    enum CellType {
        case selectedApps
        case timeLimit(TimeInterval)
        case unlockPrice(Int)
        case pushNotifications
        case emails
        case leaveFeedback

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
            case .selectedApps: return SLTexts.Settings.Settings.selectedApps.localized()
            case .timeLimit: return SLTexts.Settings.Settings.timeLimit.localized()
            case .unlockPrice: return SLTexts.Settings.Settings.unlockPrice.localized()
            case .pushNotifications: return SLTexts.Settings.Notifications.pushNotifications.localized()
            case .emails: return SLTexts.Settings.Notifications.email.localized()
            case .leaveFeedback: return SLTexts.Settings.Feedback.leaveFeedback.localized()
            }
        }

        var inputType: InputType {
            switch self {
            case .selectedApps, .leaveFeedback: return .action
            case let .timeLimit(limit): return .timeInput(limit)
            case let .unlockPrice(price): return .priceInput(price)
            case .pushNotifications, .emails: return .toggle
            }
        }
    }

    enum InputType: Equatable {
        case action
        case timeInput(TimeInterval)
        case priceInput(Int)
        case toggle

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.action, .action): return true
            case (.timeInput, .timeInput): return true
            case (.priceInput, .priceInput): return true
            case (.toggle, .toggle): return true
            default: return false
            }
        }
    }

    enum OutputType {
        case trigger
        case toggle(Bool)
        case time(TimeInterval)
        case price(Int)
    }

    enum Position {
        case single
        case top
        case middle
        case bottom
    }
}
