//
//  SummaryOtherAppsTableViewCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-10.
//

import Foundation
import SnapKit
import UIKit

// TODO: refactor cells

final class SummaryOtherAppsTableViewCell: UITableViewCell {
    private(set) var appTimeView: ARAppView?

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

        layoutUI()
    }

    private func layoutUI() {
        backgroundColor = .clear
        
        appTimeView?.removeFromSuperview()
        appTimeView = .init()
        addSubview(appTimeView!)
        appTimeView?.snp.makeConstraints {
            $0.centerY.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
}
