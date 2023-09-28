//
//  SLBaseView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-07-31.
//

import Foundation
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

    fileprivate lazy var contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        backgroundColor = SLColors.background1.getColor()

        [titleLabel, contentView].forEach(super.addSubview(_:))

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }

        contentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

    override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }

    func set(title: String?) {
        titleLabel.text = title
    }
}
