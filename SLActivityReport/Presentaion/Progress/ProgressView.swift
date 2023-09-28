//
//  ProgressView.swift
//  SLActivityReport
//
//  Created by Daniyar Kurmanbayev on 2023-09-12.
//

import Foundation
import SnapKit
import UIKit

final class ProgressView: ARView {
    private(set) lazy var dashboardView = ProgressDashboardView()

    private(set) lazy var firstContentView = SLContainerView()

    private(set) lazy var firstSectionView: ARSectionView = {
        let view = ARSectionView(titleText: type.firstSectionTitle)
        view.addContainer(view: dashboardView)
        view.addContainer(view: firstContentView)
        return view
    }()

    private(set) lazy var secondContentView = SLContainerView()

    private(set) lazy var secondSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Progress.secondSectonTitle.localized())
        view.addContainer(view: secondContentView)
        return view
    }()

    private let type: SLProgressType

    init(type: SLProgressType) {
        self.type = type

        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        getRootScrollView().contentInset = .init(top: getRootScrollView().contentInset.top,
                                                 left: getRootScrollView().contentInset.left,
                                                 bottom: type.bottomOffset,
                                                 right: getRootScrollView().contentInset.right)

        [firstSectionView, secondSectionView].forEach(add(view:))
    }
}
