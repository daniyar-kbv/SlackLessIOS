//
//  SummaryView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-06-04.
//

import Foundation
import SnapKit
import UIKit

final class SummaryView: ARView {
    private(set) lazy var firstSectionFirstContentView = SLContainerView()

    private(set) lazy var summarySelectedAppsDashboardView = SummarySelectedAppsDashboardView()

    private(set) lazy var secondSectionFirstContentView = SLContainerView()

    private(set) lazy var firstSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Summary.firstSectionTitle.localized())
        view.addContainer(view: firstSectionFirstContentView)
        view.addContainer(view: secondSectionFirstContentView)
        return view
    }()

    private(set) lazy var thirdSectionFirstContentView = SLContainerView()

//    TODO: show not enough data

    private(set) lazy var otherAppsDashboardView = SummaryOtherAppsDasboardView()

//    TODO: hide if no data

    private(set) lazy var fourthSectionFirstContentView = SLContainerView()

    private(set) lazy var secondSectionView: ARSectionView = {
        let view = ARSectionView(titleText: SLTexts.Summary.secondSectonTitle.localized())
        view.addContainer(view: thirdSectionFirstContentView)
        view.addContainer(view: fourthSectionFirstContentView)
        return view
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        layoutUI()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUI() {
        [firstSectionView, secondSectionView].forEach(add(view:))

        firstSectionFirstContentView.setContentView(summarySelectedAppsDashboardView)

        thirdSectionFirstContentView.addContent(view: otherAppsDashboardView)
    }
}
