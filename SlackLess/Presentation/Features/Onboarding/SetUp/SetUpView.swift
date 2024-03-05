//
//  SetUpView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-09-22.
//

import Foundation
import SnapKit
import UIKit

final class SetUpView: SLView {
    private let state: State
    
    private(set) lazy var largeTitleView: SLLargeTitleView = {
        let view = SLLargeTitleView()
        view.title = state.title
        view.subtitle = state.subtitle
        return view
    }()

    private(set) lazy var button: SLButton = {
        let view = SLButton(style: .filled, size: .large)
        view.setTitle(state.buttonTitle, for: .normal)
        return view
    }()

    init(state: State) {
        self.state = state
        
        super.init(frame: .zero)

        layoutUI()
    }

    private func layoutUI() {
        [button, largeTitleView].forEach { addSubview($0) }

        button.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
        }

        largeTitleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(button.snp.top)
        }
    }
}

extension SetUpView {
    enum State {
        case setUp
        case modify
        case adjust
        
        var title: String {
            switch self {
            case .setUp: return SLTexts.SetUp.Title.setUp.localized()
            case .modify: return SLTexts.SetUp.Title.modify.localized()
            case .adjust: return SLTexts.SetUp.Title.adjust.localized()
            }
        }
        
        var subtitle: String {
            switch self {
            case .setUp: return SLTexts.SetUp.Subtitle.setUp.localized()
            case .modify: return SLTexts.SetUp.Subtitle.modify.localized()
            case .adjust: return SLTexts.SetUp.Subtitle.adjust.localized()
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .setUp: return SLTexts.SetUp.ButtonTitle.setUp.localized()
            case .modify: return SLTexts.SetUp.ButtonTitle.modify.localized()
            case .adjust: return SLTexts.SetUp.ButtonTitle.adjust.localized()
            }
        }
    }
}
