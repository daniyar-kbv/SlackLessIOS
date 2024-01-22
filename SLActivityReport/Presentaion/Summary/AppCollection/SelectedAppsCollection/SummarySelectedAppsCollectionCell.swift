//
//  SummarySelectedAppsCollectionCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-08.
//

import Foundation
import SnapKit
import UIKit

final class SummarySelectedAppsCollectionCell: UICollectionViewCell {
    private(set) var appTimeView: ARAppView?

    override init(frame _: CGRect) {
        super.init(frame: .zero)

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
        contentView.addSubview(appTimeView!)
        appTimeView?.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4.5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(28)
        }
    }
}
