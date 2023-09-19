//
//  ARChartCollectionScaleCell.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-07-21.
//

import Foundation
import SnapKit
import UIKit

final class ARChartCollectionScaleCell: UICollectionViewCell {
    private var uiLaidOut = false

    private(set) var zeroTimeView: TimeView?

    private(set) lazy var timesStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()

    private(set) lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fill
        view.alignment = .fill
        return view
    }()

    func set(type: ARChartType, times: [TimeInterval]) {
        layoutUI(type: type)

        timesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var timesReordered = times

        if type == .vertical {
            timesReordered.reverse()
        }

        for time in timesReordered {
            let timeView = TimeView(type: type)
            timeView.timeLabel.text = time.formatted(with: .abbreviated, allowedUnits: [.hour])
            timesStackView.addArrangedSubview(timeView)
        }
    }

    private func layoutUI(type: ARChartType) {
        guard !uiLaidOut else { return }
        uiLaidOut = true

        zeroTimeView = TimeView(type: type)
        zeroTimeView?.timeLabel.text = "0"

        addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        switch type {
        case .horizontal:
            [zeroTimeView!, timesStackView].forEach(mainStackView.addArrangedSubview(_:))
            mainStackView.axis = .horizontal
            timesStackView.axis = .horizontal
            zeroTimeView?.snp.makeConstraints {
                $0.width.equalTo(20)
            }
        case .vertical:
            [timesStackView, zeroTimeView!].forEach(mainStackView.addArrangedSubview(_:))
            mainStackView.axis = .vertical
            timesStackView.axis = .vertical
            zeroTimeView?.snp.makeConstraints {
                $0.height.equalTo(20)
            }
        }
    }
}

extension ARChartCollectionScaleCell {
    final class TimeView: UIView {
        private let type: ARChartType

        private(set) lazy var timeLabel: UILabel = {
            let view = UILabel()
            view.textColor = SLColors.gray4.getColor()
            view.font = SLFonts.primary.getFont(ofSize: 11, weight: .regular)
            view.textAlignment = .right
            view.adjustsFontSizeToFitWidth = true
            return view
        }()

        override func layoutSubviews() {
            super.layoutSubviews()

            switch type {
            case .horizontal: redrawDashedLine(on: .right)
            case .vertical: redrawDashedLine(on: .top)
            }
        }

        init(type: ARChartType) {
            self.type = type

            super.init(frame: .zero)

            layoutUI()
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func layoutUI() {
            switch type {
            case .horizontal: addDashedLine(on: .right)
            case .vertical: addDashedLine(on: .top)
            }

            [timeLabel].forEach(addSubview(_:))

            timeLabel.snp.makeConstraints {
                $0.top.right.equalToSuperview().inset(4)
                $0.left.equalToSuperview()
            }
        }
    }
}
