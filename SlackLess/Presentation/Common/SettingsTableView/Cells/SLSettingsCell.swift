//
//  SLSettingsCell.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-29.
//

import FamilyControls
import Foundation
import RxCocoa
import RxSwift
import SnapKit
import SwiftUI
import UIKit

final class SLSettingsCell: UITableViewCell {
    private var type: CellType?
    private var output: ((Output) -> Void)?
    private var appsSelectionHostingController: UIHostingController<SLAppsSelectionView>?
    weak var parentConroller: UIViewController?
    private var disposeBag = DisposeBag()

    var isEnabled = true {
        didSet {
            isUserInteractionEnabled = isEnabled
            contentView.alpha = isEnabled ? 1 : 0.5
        }
    }

    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = SLColors.backgroundElevated.getColor()
        view.clipsToBounds = true
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

        disposeBag = .init()
        type = nil
        output = nil
        rightItemView.subviews.forEach { $0.removeFromSuperview() }
        if let appsSelectionHostingController = appsSelectionHostingController {
            parentConroller?.remove(controller: appsSelectionHostingController)
            self.appsSelectionHostingController = nil
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        switch type {
        case .selectedApps, .leaveFeedback:
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.containerView.backgroundColor = highlighted ? SLColors.gray5.getColor() : SLColors.backgroundElevated.getColor()
            }
        default: break
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

    func set(type: CellType, position: Position, output: @escaping (Output) -> Void) {
        self.type = type
        self.output = output

        iconView.image = type.image
        titleLabel.text = type.title

        var inputView: UIView?

        switch type {
        case let .selectedApps(_, selection):
            inputView = UIImageView(image: SLImages.Common.Arrows.Chevron.right.getImage())

            appsSelectionHostingController = .init(rootView: .init(
                selection: selection,
                onSelect: { [weak self] in
                    self?.output?(.appsSelection($0))
                }
            ))
            parentConroller?.add(controller: appsSelectionHostingController!, to: containerView)
            appsSelectionHostingController?.view.backgroundColor = .clear
        case let .timeLimit(_, limit):
            inputView = SLTableInput(type: .time, value: limit) { [weak self] in
                self?.output?(.time($0))
            }
        case let .unlockPrice(_, price):
            inputView = SLTableInput(type: .price, value: price) { [weak self] in
                self?.output?(.price($0))
            }
        case let .pushNotifications(enabled):
            let switch_ = UISwitch()
            switch_.isOn = enabled
            switch_.rx.controlEvent(.valueChanged)
                .withLatestFrom(switch_.rx.value)
                .subscribe(onNext: { [weak self] in
                    self?.output?(.pushNotifications($0))
                })
                .disposed(by: disposeBag)
            inputView = switch_
        case .emails:
            let switch_ = UISwitch()
            inputView = switch_
        case .leaveFeedback:
            inputView = UIImageView(image: SLImages.Common.Arrows.Chevron.right.getImage())
        }

        if let inputView = inputView {
            rightItemView.addSubview(inputView)
            inputView.snp.makeConstraints {
                $0.edges.equalToSuperview()
                switch type {
                case .selectedApps, .leaveFeedback:
                    $0.size.equalTo(16)
                default: break
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
    enum CellType: Equatable {
        case selectedApps(SLSettingsType, FamilyActivitySelection)
        case timeLimit(SLSettingsType, TimeInterval?)
        case unlockPrice(SLSettingsType, Double?)
        case pushNotifications(Bool)
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
            case let .selectedApps(settingsType, _):
                switch settingsType {
                case .display, .full: return SLTexts.Settings.Settings.SelectedAppsLabel.normal.localized()
                case .setUp: return SLTexts.Settings.Settings.SelectedAppsLabel.setUp.localized()
                }
            case let .timeLimit(settingsType, _):
                switch settingsType {
                case .display, .full: return SLTexts.Settings.Settings.TimeLimitLabel.normal.localized()
                case .setUp: return SLTexts.Settings.Settings.TimeLimitLabel.setUp.localized()
                }
            case let .unlockPrice(settingsType, _):
                switch settingsType {
                case .display, .full: return SLTexts.Settings.Settings.UnlockPrice.Label.normal.localized()
                case .setUp: return SLTexts.Settings.Settings.UnlockPrice.Label.setUp.localized()
                }
            case .pushNotifications: return SLTexts.Settings.Notifications.pushNotifications.localized()
            case .emails: return SLTexts.Settings.Notifications.email.localized()
            case .leaveFeedback: return SLTexts.Settings.Feedback.leaveFeedback.localized()
            }
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.selectedApps, .selectedApps): return true
            case (.timeLimit, .timeLimit): return true
            case (.unlockPrice, .unlockPrice): return true
            case (.pushNotifications, .pushNotifications): return true
            case (.emails, .emails): return true
            case (.leaveFeedback, .leaveFeedback): return true
            default: return false
            }
        }
    }

    enum Output {
        case appsSelection(FamilyActivitySelection)
        case time(TimeInterval?)
        case price(Double?)
        case pushNotifications(Bool)
    }

    enum Position {
        case single
        case top
        case middle
        case bottom
    }
}
