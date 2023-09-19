//
//  UIVIew.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import UIKit

extension UIView {
    func addDashedLine(on side: ARDashedView.Side) {
        guard getDashedContainerView(on: side) == nil else { return }
        let dashedContainerView = DashedContainerView(side: side)
        addSubview(dashedContainerView)
        dashedContainerView.snp.makeConstraints {
            switch side {
            case .top: $0.top.horizontalEdges.equalToSuperview()
            case .bottom: $0.bottom.horizontalEdges.equalToSuperview()
            case .left: $0.left.verticalEdges.equalToSuperview()
            case .right: $0.right.verticalEdges.equalToSuperview()
            }
        }
    }

    func removeDashedLine(on side: ARDashedView.Side) {
        getDashedContainerView(on: side)?.removeFromSuperview()
    }

    func redrawDashedLine(on side: ARDashedView.Side,
                          strokeColor: CGColor? = SLColors.gray4.getColor()?.cgColor,
                          lineWidth: CGFloat = 0.5,
                          lineDashPattern: [NSNumber]? = [2, 2])
    {
        guard let dashedContainerView = getDashedContainerView(on: side) else { return }
        dashedContainerView.subviews.forEach { $0.removeFromSuperview() }
        let dashedLineView = ARDashedView(strokeColor: strokeColor,
                                          lineWidth: lineWidth,
                                          lineDashPattern: lineDashPattern)
        dashedContainerView.addSubview(dashedLineView)
        dashedLineView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func getDashedContainerView(on side: ARDashedView.Side) -> DashedContainerView? {
        return subviews.first(where: { $0 is DashedContainerView && ($0 as? DashedContainerView)?.side == side }) as? DashedContainerView
    }

    fileprivate class DashedContainerView: UIView {
        let side: ARDashedView.Side

        init(side: ARDashedView.Side) {
            self.side = side

            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
