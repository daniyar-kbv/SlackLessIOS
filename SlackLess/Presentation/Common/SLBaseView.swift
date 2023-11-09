//
//  SLBaseView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class SLBaseView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = SLFonts.primary.getFont(ofSize: 28, weight: .bold)
        view.textColor = SLColors.label1.getColor()
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private(set) lazy var unlockButton: SLButton = {
        let view = SLButton(style: .filled, size: .small)
        view.setTitle(SLTexts.Unlock.buttonTitle.localized(), for: .normal)
        view.isHidden = true
        return view
    }()

    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, unlockButton])
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()

    fileprivate lazy var contentView = UIView()
    fileprivate let diposeBag = DisposeBag()
    let unlockButtonTap: PublishRelay<Void> = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
        bindView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = SLColors.background1.getColor()

        [stackView, contentView].forEach(super.addSubview(_:))

        stackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    private func bindView() {
        unlockButton.rx.tap
            .bind(to: unlockButtonTap)
            .disposed(by: diposeBag)
    }

    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }

    func set(title: String?) {
        titleLabel.text = title
    }
}
