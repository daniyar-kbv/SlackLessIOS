//
//  CustomizeView.swift
//  SlackLess
//
//  Created by Daniyar Kurmanbayev on 2023-12-04.
//

import Foundation
import UIKit
import SnapKit

final class CustomizeView: SLBaseView {
    private(set) lazy var settingsView = UIView()
    
    private(set) lazy var debugButton: UIButton = {
        let view = UIButton()
        view.setTitle("Show Set Up", for: .normal)
        view.setTitleColor(SLColors.label2.getColor(), for: .normal)
        view.setBackgroundColor(color: .blue, forState: .normal)
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
    
    func layoutUI() {
//        TODO: Remove
//        switch Constants.Settings.environmentType {
//        case .production:
            [settingsView].forEach(addSubview(_:))
            
            settingsView.snp.makeConstraints {
                $0.verticalEdges.equalTo(safeAreaLayoutGuide)
                $0.horizontalEdges.equalToSuperview()
            }
//        default:
//            [settingsView, debugButton].forEach(addSubview(_:))
//
//            settingsView.snp.makeConstraints {
//                $0.top.equalTo(safeAreaLayoutGuide)
//                $0.horizontalEdges.equalToSuperview()
//            }
//
//            debugButton.snp.makeConstraints {
//                $0.top.equalTo(settingsView.snp.bottom)
//                $0.horizontalEdges.equalToSuperview()
//                $0.bottom.equalTo(safeAreaLayoutGuide)
//            }
//        }
    }
}
