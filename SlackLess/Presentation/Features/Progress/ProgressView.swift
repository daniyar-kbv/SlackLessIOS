//
//  ProgressView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-08-02.
//

import Foundation
import SnapKit
import UIKit

final class ProgressView: SLBaseView {
    private(set) lazy var dateSwitcherView = SLDateSwitcherView()

    private(set) lazy var reportView = UIView()

    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateSwitcherView, reportView])
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 8
        return view
    }()

    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.setTitle(SLTexts.Button.continue_.localized(), for: .normal)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [stackView, button].forEach(addSubview(_:))

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        dateSwitcherView.snp.makeConstraints {
            $0.height.equalTo(28)
        }

        button.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    func addTopOffset(_ add: Bool) {
        guard add else { return }
        titleLabel.snp.updateConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
        }
    }
}
